import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  Group(this.id, this.name, this.timestamp, this.members);

  String id;
  String name;
  Timestamp timestamp;
  List<String> members;
}
