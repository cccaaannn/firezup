import 'package:firebase_auth/firebase_auth.dart';
import 'package:firezup/services/user_service.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/utils/keystore_utils.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UserService userService = UserService();

  Future<Optional<AppUser>> login(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user == null) {
        return Optional(null);
      }

      Optional<AppUser> userOptional = await userService.getUserById(user.uid);

      if (!userOptional.exists()) {
        return Optional(null);
      }

      await KeystoreUtils.saveUserDetails(userOptional.get()!);

      return userOptional;
    } on FirebaseAuthException catch (e) {
      return Optional(null);
    }
  }

  Future<Optional<AppUser>> register(
      String username, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user == null) {
        return Optional(null);
      }

      return userService.updateUser(user.uid, username, email);
    } on FirebaseAuthException catch (e) {
      return Optional(null);
    }
  }

  bool isLoggedIn() {
    User? user = firebaseAuth.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> logout() async {
    try {
      await KeystoreUtils.removeUserDetails();
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
