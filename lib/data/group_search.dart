import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSearch {
  GroupSearch(this.id, this.name, this.timestamp, this.joined);

  String id;
  String name;
  Timestamp timestamp;
  bool joined;
}
