import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/message.dart';
import 'package:firezup/data/optional.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final Optional<Message> messageOptional;

  const MessageTile({super.key, required this.messageOptional});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  final Message emptyMessage = Message("", "", "", Timestamp.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.messageOptional.getOrDefault(emptyMessage).content),
    );
  }
}
