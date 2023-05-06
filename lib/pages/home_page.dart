import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/message.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/services/snackbar_service.dart';
import 'package:firezup/services/user_service.dart';
import 'package:firezup/shared/pages.dart';
import 'package:firezup/widgets/app_drawer.dart';
import 'package:firezup/widgets/create_group_modal.dart';
import 'package:firezup/widgets/group_tile.dart';
import 'package:firezup/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GroupService groupService = GroupService();
  final UserService userService = UserService();

  Optional<AppUser> userOptional = Optional(null);
  Stream? groupsSnapshot;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    Stream<QuerySnapshot<Object?>> snapshot =
        await groupService.getUserGroupsSnapshot();
    setState(() => groupsSnapshot = snapshot);

    userOptional = await userService.getActiveUser();
    setState(() => userOptional = userOptional);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Home",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer:
          AppDrawer(userOptional: userOptional, selectedPage: AppPages.home),
      body: groupListStream(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createGroupModal(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  groupListStream() {
    return StreamBuilder(
      stream: groupsSnapshot,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Loading();
        }

        var docs = snapshot.data.docs;

        if (docs == null) {
          return const Loading();
        }

        if (docs.length == 0) {
          return const Loading();
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            int reverseIndex = docs.length - index - 1;

            // Get last message detail
            Map<String, dynamic> lastMessageDetail =
                docs[reverseIndex].data()["lastMessage"];

            Message? lastMessage;
            if (lastMessageDetail.isNotEmpty) {
              lastMessage = Message(
                  null,
                  "${lastMessageDetail['content']}",
                  "${lastMessageDetail['owner']}",
                  lastMessageDetail['timestamp']);
            }
            Optional<Message> lastMessageOptional = Optional(lastMessage);

            return GroupTile(
              groupName: docs[reverseIndex].data()["name"],
              lastMessageOptional: lastMessageOptional,
            );
          },
        );
      },
    );
  }

  createGroupModal(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const CreateGroupModal();
        });
  }
}
