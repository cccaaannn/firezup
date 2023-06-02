import 'package:flutter/material.dart';

class AccountInfoUserTile extends StatelessWidget {
  final String username;
  final String email;

  const AccountInfoUserTile(
      {super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            username.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(username),
        subtitle: Text(email),
      ),
    );
  }
}
