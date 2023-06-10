import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/message.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/utils/string_utils.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final Optional<Message> messageOptional;
  const MessageTile({super.key, required this.messageOptional});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  final Message emptyMessage = Message("", "", "", Timestamp.now(), false);
  bool sendByMe = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      sendByMe = widget.messageOptional.getOrDefault(emptyMessage).sendByMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2,
        bottom: 4,
        left: sendByMe ? 0 : 15,
        right: sendByMe ? 15 : 0,
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 200,
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          color: sendByMe ? Theme.of(context).primaryColor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringUtils.splitName(
                  widget.messageOptional.getOrDefault(emptyMessage).owner),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.messageOptional.getOrDefault(emptyMessage).content,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
