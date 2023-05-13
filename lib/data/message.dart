import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message(this.id, this.content, this.owner, this.timestamp);

  String? id;
  String content;
  String owner;
  Timestamp? timestamp;
}
