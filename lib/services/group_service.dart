import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firezup/data/group.dart';
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

    DocumentReference documentReference = await groupCollection.add({
      "id": "",
      "name": groupName,
      "timestamp": FieldValue.serverTimestamp(),
      "lastMessage": {},
      "members": ["${uid}_${user.username}"]
    });

    await documentReference.update({"id": documentReference.id});

    await userCollection.doc(uid).update({
      "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"])
    });

    Timestamp createdTime = (await documentReference.get()).get("timestamp");

    Group group = Group(documentReference.id, groupName, createdTime, null,
        List.empty(), List.empty());

    return Optional(group);
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
