import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firezup/data/message.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/pages/group_info.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/services/navigation_service.dart';
import 'package:firezup/utils/validation_utils.dart';
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
  TextEditingController messageTextController = TextEditingController();
  GroupService groupService = GroupService();
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
              NavigationService(context).next(const GroupInfo());
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          getMessages(),
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

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> messageDetail = docs[index].data();

            Message? message;
            if (messageDetail.isNotEmpty) {
              message = Message(
                "${messageDetail['id']}",
                "${messageDetail['content']}",
                "${messageDetail['owner']}",
                messageDetail['timestamp'],
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
      setState(() => newMessage = "");
      messageTextController.clear();
    }
  }
}
