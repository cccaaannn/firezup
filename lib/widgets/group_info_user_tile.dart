import 'package:firezup/utils/string_utils.dart';
import 'package:flutter/material.dart';

class GroupInfoUserTile extends StatelessWidget {
  final String userIDName;
  final bool isOwner;

  const GroupInfoUserTile(
      {super.key, required this.userIDName, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isOwner ? Theme.of(context).primaryColor.withOpacity(0.2) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            StringUtils.splitName(userIDName).substring(0, 1).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(StringUtils.splitName(userIDName)),
        subtitle: isOwner ? const Text("Owner") : null,
      ),
    );
  }
}
