import 'package:firezup/data/message.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/pages/chat_page.dart';
import 'package:firezup/services/navigation_service.dart';
import 'package:firezup/utils/date_utils.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String groupName;
  final Optional<Message> lastMessageOptional;

  const GroupTile(
      {Key? key, required this.groupName, required this.lastMessageOptional})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService(context).next(const ChatPage());
        //   ChatPage(
        //     group: widget.group,
        //     userName: widget.userName,
        //   ),
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Row(
            children: [
              Text(
                widget.groupName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                MessageDateUtils.formatForMessageDate(
                    widget.lastMessageOptional.get()?.timestamp),
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          subtitle: widget.lastMessageOptional.exists()
              ? Text.rich(
                  TextSpan(
                    text: "${widget.lastMessageOptional.get()?.owner}: ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.lastMessageOptional.get()?.content,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                )
              : const Text(
                  "No messages yet",
                  style: TextStyle(fontSize: 13),
                ),
        ),
      ),
    );
  }
}
