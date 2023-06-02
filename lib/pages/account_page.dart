import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/user_service.dart';
import 'package:firezup/shared/pages.dart';
import 'package:firezup/widgets/app_drawer.dart';
import 'package:firezup/widgets/account_info_user_tile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService userService = UserService();
  final AppUser loadingUser = AppUser("", "?", "?");
  Optional<AppUser> userOptional = Optional(null);

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    userOptional = await userService.getActiveUser();
    setState(() => userOptional = userOptional);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Account",
        ),
      ),
      drawer:
          AppDrawer(userOptional: userOptional, selectedPage: AppPages.account),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: AccountInfoUserTile(
          username: userOptional.getOrDefault(loadingUser).username,
          email: userOptional.getOrDefault(loadingUser).email,
        ),
      ),
    );
  }
}
