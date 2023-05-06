import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firezup/shared/db_collections.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(DBCollections.userCollectionName);

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

  Future<Optional<AppUser>> getActiveUser() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Optional(null);
    }

    return getUserById(uid);
  }

//   Future getUserGroups() async {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;

//     if (uid == null) {
//       throw ArgumentError();
//     }
//     return userCollection.doc(uid).snapshots();
//   }

  Future<Optional<AppUser>> updateUser(
      String docId, String username, String email) async {
    await userCollection
        .doc(docId)
        .set({"id": docId, "username": username, "email": email, "groups": []});

    return Optional(AppUser(docId, email, username));
  }
}
