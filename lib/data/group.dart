import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/message.dart';

class Group {
  Group(this.id, this.name, this.timestamp, this.lastMessage, this.messages,
      this.members);

  String id;
  String name;
  Timestamp timestamp;
  Message? lastMessage;
  List<Message> messages;
  List<String> members;
}
