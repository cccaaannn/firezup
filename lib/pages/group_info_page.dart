import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/group_info.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/utils/string_utils.dart';
import 'package:firezup/widgets/group_info_user_tile.dart';
import 'package:flutter/material.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupInfoPage(
      {super.key, required this.groupId, required this.groupName});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final GroupService groupService = GroupService();

  Stream<DocumentSnapshot<Object?>>? membersSnapshot;
  Optional<GroupInfo> groupOptional = Optional(null);

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    Stream<DocumentSnapshot<Object?>> snapshot =
        await groupService.getGroupMembersSnapshot(widget.groupId);
    setState(() => membersSnapshot = snapshot);

    groupOptional = await groupService.getGroupById(widget.groupId);
    setState(() => groupOptional = groupOptional);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          children: [
            Text(widget.groupName),
            const Text(
              "Members",
              style: TextStyle(
                fontWeight: FontWeight.w200,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: getMembersList(),
      ),
    );
  }

  getMembersList() {
    return StreamBuilder(
      stream: membersSnapshot,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        var data = snapshot.data;

        if (data == null) {
          return Container();
        }

        if (data['members'] == null) {
          return Container();
        }

        if (data['members'].length == 0) {
          return Container();
        }

        return ListView.builder(
          itemCount: data['members'].length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GroupInfoUserTile(
              userIDName: data['members'][index],
              isOwner: data['members'][index] == groupOptional.get()?.owner,
            );
          },
        );
      },
    );
  }
}
