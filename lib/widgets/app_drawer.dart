import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/pages/auth/login_page.dart';
import 'package:firezup/pages/home_page.dart';
import 'package:firezup/pages/profile_page.dart';
import 'package:firezup/services/auth_service.dart';
import 'package:firezup/services/navigation_service.dart';
import 'package:firezup/shared/pages.dart';
import 'package:firezup/widgets/loading.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final Optional<AppUser> userOptional;
  final AppPages selectedPage;

  const AppDrawer(
      {super.key, required this.userOptional, required this.selectedPage});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService authService = AuthService();
  final AppUser fallbackUser = AppUser("", "", "");

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: !widget.userOptional.exists()
          ? const Loading()
          : Column(
              children: <Widget>[
                Expanded(
                  // ListView contains a group of widgets that scroll inside the drawer
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountEmail: Text(widget.userOptional
                            .getOrDefault(fallbackUser)
                            .email),
                        accountName: Text(widget.userOptional
                            .getOrDefault(fallbackUser)
                            .username),
                        currentAccountPictureSize: const Size(60, 60),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        currentAccountPicture: CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: Text(
                            widget.userOptional
                                .getOrDefault(fallbackUser)
                                .username
                                .substring(0, 1)
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          ),
                        ),
                      ),
                      ListTile(
                        selectedColor: Theme.of(context).primaryColor,
                        selected:
                            widget.selectedPage.index == AppPages.home.index,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.home),
                        onTap: () {
                          NavigationService(context).replace(const HomePage());
                        },
                        title: const Text(
                          "Home",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        selectedColor: Theme.of(context).primaryColor,
                        onTap: () {
                          NavigationService(context)
                              .replace(const ProfilePage());
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        selected:
                            widget.selectedPage.index == AppPages.profile.index,
                        leading: const Icon(
                          Icons.person,
                        ),
                        title: const Text(
                          "Profile",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                            child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                              onTap: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Logout"),
                                        content: const Text(
                                            "Are you sure you want to logout?"),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await authService.logout();

                                              NavigationService(context)
                                                  .replace(const LoginPage());

                                              // Navigator.of(context).pushAndRemoveUntil(
                                              //     MaterialPageRoute(
                                              //         builder: (context) => const LoginPage()),
                                              //     (route) => false);
                                            },
                                            icon: const Icon(
                                              Icons.done,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              leading: const Icon(Icons.exit_to_app),
                              title: const Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ))))
              ],
            ),
    );
  }
}
