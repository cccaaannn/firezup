import 'package:firezup/data/app_user.dart';
import 'package:firezup/shared/keystore_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeystoreUtils {
  static Future<void> saveUserDetails(AppUser appUser) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.setString(KeystoreKeys.userNameKey, appUser.username);
    await sf.setString(KeystoreKeys.userEmailKey, appUser.email);
  }

  static Future<void> removeUserDetails() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.remove(KeystoreKeys.userNameKey);
    await sf.remove(KeystoreKeys.userEmailKey);
  }
}
