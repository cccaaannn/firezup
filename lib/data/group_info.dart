import 'package:cloud_firestore/cloud_firestore.dart';

class GroupInfo {
  GroupInfo(this.id, this.name, this.timestamp, this.owner);

  String id;
  String name;
  Timestamp timestamp;
  String owner;
}
