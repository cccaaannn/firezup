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

  Future<Optional<AppUser>> getUserById(String docId) async {
    DocumentReference userDoc = userCollection.doc(docId);

    DocumentSnapshot<Object?> userDocSnapshot = await userDoc.get();

    if (!userDocSnapshot.exists) {
      return Optional(null);
    }

    AppUser appUser = AppUser(userDocSnapshot.id, userDocSnapshot.get("email"),
        userDocSnapshot.get("username"));

    return Optional(appUser);
  }
}
