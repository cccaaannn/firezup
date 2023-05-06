import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/user_service.dart';
import 'package:firezup/shared/pages.dart';
import 'package:firezup/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService userService = UserService();
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer:
          AppDrawer(userOptional: userOptional, selectedPage: AppPages.profile),
      body: const Text("Hello"),
    );
  }
}
