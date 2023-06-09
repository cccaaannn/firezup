import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/message.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/services/user_service.dart';
import 'package:firezup/shared/pages.dart';
import 'package:firezup/utils/string_utils.dart';
import 'package:firezup/widgets/drawer/app_drawer.dart';
import 'package:firezup/widgets/modal/create_group_modal.dart';
import 'package:firezup/widgets/util/empty_home_placeholder.dart';
import 'package:firezup/widgets/tile/group_tile.dart';
import 'package:firezup/widgets/util/loading.dart';
import 'package:firezup/widgets/modal/search_group_modal.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GroupService groupService = GroupService();
  final UserService userService = UserService();

  Optional<AppUser> userOptional = Optional(null);
  Stream<QuerySnapshot<Object?>>? groupsSnapshot;

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
        actions: [
          IconButton(
            onPressed: () {
              searchGroupModal(context);
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Home",
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
          Icons.add,
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
          return const EmptyHomePlaceholder();
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            int reverseIndex = docs.length - index - 1;

            // Get last message detail
            Map<String, dynamic> lastMessageMap =
                docs[reverseIndex].data()["lastMessage"];

            String userId = "";
            if (userOptional.exists()) {
              userId = userOptional.get()!.id;
            }

            Message? lastMessage;
            if (lastMessageMap.isNotEmpty) {
              lastMessage = Message(
                "${lastMessageMap['id']}",
                "${lastMessageMap['content']}",
                "${lastMessageMap['owner']}",
                lastMessageMap['timestamp'],
                StringUtils.splitID(lastMessageMap['owner']) == userId,
              );
            }
            Optional<Message> lastMessageOptional = Optional(lastMessage);

            return GroupTile(
              groupId: docs[reverseIndex].data()["id"],
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
      },
    );
  }

  searchGroupModal(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const SearchGroupModal();
      },
    );
  }
}
