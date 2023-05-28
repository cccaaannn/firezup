import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firezup/data/group.dart';
import 'package:firezup/data/group_info.dart';
import 'package:firezup/data/group_search.dart';
import 'package:firezup/services/user_service.dart';
import 'package:firezup/shared/db_collections.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';

class GroupService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(DBCollections.userCollectionName);
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection(DBCollections.groupsCollectionName);

  UserService userService = UserService();

  Future<Stream<QuerySnapshot<Object?>>> getUserGroupsSnapshot() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      throw ArgumentError();
    }

    Optional<AppUser> userOptional = await userService.getUserById(uid);

    if (!userOptional.exists()) {
      throw ArgumentError();
    }
    AppUser user = userOptional.get()!;

    // return userCollection.doc(uid).snapshots();

    return groupCollection
        .where("members", arrayContains: "${uid}_${user.username}")
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Object?>>> getGroupMessagesSnapshot(
      String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }

  Future<Stream<DocumentSnapshot<Object?>>> getGroupMembersSnapshot(
      String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  Future<Optional<GroupInfo>> getGroupById(String groupId) async {
    DocumentReference userDoc = groupCollection.doc(groupId);

    DocumentSnapshot<Object?> groupDocSnapshot = await userDoc.get();

    if (!groupDocSnapshot.exists) {
      return Optional(null);
    }

    GroupInfo groupInfo = GroupInfo(
      groupDocSnapshot.id,
      groupDocSnapshot.get("name"),
      groupDocSnapshot.get("timestamp"),
      groupDocSnapshot.get("owner"),
    );

    return Optional(groupInfo);
  }

  Future<Optional<Group>> createGroup(String groupName) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Optional(null);
    }

    Optional<AppUser> userOptional = await userService.getUserById(uid);

    if (!userOptional.exists()) {
      return Optional(null);
    }
    AppUser user = userOptional.get()!;
    String owner = "${uid}_${user.username}";

    DocumentReference documentReference = await groupCollection.add({
      "id": "",
      "name": groupName,
      "timestamp": FieldValue.serverTimestamp(),
      "lastMessage": {},
      "members": [owner],
      "owner": owner
    });

    await documentReference.update({"id": documentReference.id});

    await userCollection.doc(uid).update({
      "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"])
    });

    Timestamp createdTime = (await documentReference.get()).get("timestamp");

    Group group = Group(
      documentReference.id,
      groupName,
      createdTime,
      List.empty(),
      owner,
    );

    return Optional(group);
  }

  Future<bool> leaveGroup(String groupId) async {
    Optional<AppUser> userOptional = await userService.getActiveUser();
    if (!userOptional.exists()) {
      return false;
    }
    AppUser user = userOptional.get()!;

    DocumentReference<Object?> groupDoc = groupCollection.doc(groupId);
    DocumentSnapshot<Object?> groupObj = await groupDoc.get();
    if (!groupObj.exists) {
      return false;
    }

    Map<String, dynamic> groupMap = groupObj.data() as Map<String, dynamic>;
    String groupName = groupMap["name"];

    await groupDoc.update({
      "members": FieldValue.arrayRemove(["${user.id}_${user.username}"])
    });

    await userCollection.doc(user.id).update({
      "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
    });

    return true;
  }

  Future<bool> joinGroup(String groupId) async {
    Optional<AppUser> userOptional = await userService.getActiveUser();
    if (!userOptional.exists()) {
      return false;
    }
    AppUser user = userOptional.get()!;

    DocumentReference<Object?> groupDoc = groupCollection.doc(groupId);
    DocumentSnapshot<Object?> groupObj = await groupDoc.get();
    if (!groupObj.exists) {
      return false;
    }

    Map<String, dynamic> groupMap = groupObj.data() as Map<String, dynamic>;
    String groupName = groupMap["name"];

    await groupDoc.update({
      "members": FieldValue.arrayUnion(["${user.id}_${user.username}"])
    });

    await userCollection.doc(user.id).update({
      "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
    });

    return true;
  }

  Future<List<GroupSearch>> searchByName(String groupName) async {
    List<GroupSearch> groupSearchList = List.empty(growable: true);

    Optional<AppUser> userOptional = await userService.getActiveUser();
    if (!userOptional.exists()) {
      return groupSearchList;
    }
    AppUser user = userOptional.get()!;

    QuerySnapshot<Object?> snapshot =
        await groupCollection.where("name", isEqualTo: groupName).get();

    if (snapshot.docs.isEmpty) {
      return groupSearchList;
    }
    if (snapshot.docs[0].data() == null) {
      return groupSearchList;
    }

    List<QueryDocumentSnapshot<Object?>> groupList = snapshot.docs;

    for (QueryDocumentSnapshot<Object?> groupSnapshot in groupList) {
      Map<String, dynamic> groupMap =
          groupSnapshot.data() as Map<String, dynamic>;

      bool contains =
          groupMap["members"].contains("${user.id}_${user.username}");

      GroupSearch group = GroupSearch(
          "${groupMap['id']}",
          "${groupMap['name']}",
          groupMap['timestamp'],
          !contains,
          groupMap['owner']);

      groupSearchList.add(group);
    }

    return groupSearchList;
  }

  Future sendMessage(String groupId, String messageContent) async {
    Optional<AppUser> userOptional = await userService.getActiveUser();
    if (!userOptional.exists()) {
      return;
    }
    AppUser user = userOptional.get()!;

    CollectionReference<Object?> newMessageRef = groupCollection
        .doc(groupId)
        .collection(DBCollections.messagesCollectionName);
    await newMessageRef.add({
      "id": newMessageRef.id,
      "content": messageContent,
      "owner": "${user.id}_${user.username}",
      "timestamp": FieldValue.serverTimestamp()
    });

    await groupCollection.doc(groupId).update({
      "lastMessage": {
        "id": newMessageRef.id,
        "content": messageContent,
        "owner": "${user.id}_${user.username}",
        "timestamp": FieldValue.serverTimestamp()
      }
    });

    return;
  }
}
