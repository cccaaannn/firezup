import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/message.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/pages/group_info_page.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/services/navigation_service.dart';
import 'package:firezup/services/user_service.dart';
import 'package:firezup/utils/string_utils.dart';
import 'package:firezup/widgets/custom_input.dart';
import 'package:firezup/widgets/message_tile.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const ChatPage({super.key, required this.groupId, required this.groupName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final GroupService groupService = GroupService();
  final UserService userService = UserService();

  Optional<AppUser> userOptional = Optional(null);
  Stream<QuerySnapshot<Object?>>? messagesSnapshot;

  String newMessage = "";

  @override
  void initState() {
    super.initState();
    initMessageData();
  }

  initMessageData() async {
    Stream<QuerySnapshot<Object?>> snapshot =
        await groupService.getGroupMessagesSnapshot(widget.groupId);
    setState(() => messagesSnapshot = snapshot);

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
        title: Text(widget.groupName),
        actions: [
          IconButton(
            onPressed: () {
              NavigationService(context).next(
                GroupInfoPage(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 65),
            child: getMessages(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                setState(() => newMessage = value);
              },
              decoration: customInput.copyWith(
                hintText: "Type a message...",
                suffixIcon: IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              controller: messageTextController,
            ),
          ),
        ],
      ),
    );
  }

  getMessages() {
    return StreamBuilder(
      stream: messagesSnapshot,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        var docs = snapshot.data.docs;

        if (docs == null) {
          return Container();
        }

        if (docs.length == 0) {
          return Container();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

        return ListView.builder(
          controller: scrollController,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> messageMap = docs[index].data();

            String userId = "";
            if (userOptional.exists()) {
              userId = userOptional.get()!.id;
            }

            Message? message;
            if (messageMap.isNotEmpty) {
              message = Message(
                "${messageMap['id']}",
                "${messageMap['content']}",
                "${messageMap['owner']}",
                messageMap['timestamp'],
                StringUtils.splitID(messageMap['owner']) == userId,
              );
            }
            Optional<Message> messageOptional = Optional(message);

            return MessageTile(
              messageOptional: messageOptional,
            );
          },
        );
      },
    );
  }

  void sendMessage() async {
    if (newMessage != "") {
      await groupService.sendMessage(widget.groupId, newMessage);
      setState(
        () {
          newMessage = "";
          scrollToBottom();
        },
      );
      messageTextController.clear();
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
      //   scrollController.animateTo(
      //     scrollController.position.maxScrollExtent,
      //     curve: Curves.easeOut,
      //     duration: const Duration(milliseconds: 500),
      //   );
    }
  }
}
