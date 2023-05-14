import 'package:firezup/data/group_search.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/utils/validation_utils.dart';
import 'package:firezup/widgets/join_group_button.dart';
import 'package:firezup/widgets/loading.dart';
import 'package:firezup/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class SearchGroupModal extends StatefulWidget {
  const SearchGroupModal({super.key});

  @override
  State<SearchGroupModal> createState() => _SearchGroupModalState();
}

class _SearchGroupModalState extends State<SearchGroupModal> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isInitialLoad = true;
  GroupSearch? group;
  String groupName = "";

  GroupService groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: ((context, setState) {
        return AlertDialog(
          title: const Text(
            "Search groups",
            textAlign: TextAlign.left,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: loading
                ? [const Loading()]
                : [
                    Form(
                      key: formKey,
                      child: TextFormField(
                        decoration: customInput.copyWith(
                          labelText: "Group name",
                          prefixIcon: Icon(
                            Icons.group,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => groupName = val);
                        },
                        // check tha validation
                        validator: (val) {
                          return ValidationUtils()
                              .requiredString(val, "Group name")
                              .getMessage();
                        },
                      ),
                    ),
                    group != null
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  group!.name.substring(0, 1).toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    group!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  JoinGroupButton(
                                    groupSearch: group,
                                    joinGroup: joinGroup,
                                    leaveGroup: leaveGroup,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(isInitialLoad ? "" : "Not found")
                            ],
                          ),
                  ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await searchGroup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text("Search"),
            )
          ],
        );
      }),
    );
  }

  searchGroup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
      isInitialLoad = false;
    });
    Optional<GroupSearch> groupOptional =
        await groupService.searchByName(groupName);
    setState(() => loading = false);

    if (!groupOptional.exists()) {
      setState(() => group = null);
      return;
    }

    setState(() => group = groupOptional.get());
  }

  joinGroup() async {
    if (group == null) {
      return;
    }

    setState(() => loading = true);
    await groupService.joinGroup(group!.id);
    Optional<GroupSearch> groupOptional =
        await groupService.searchByName(groupName);
    setState(() => loading = false);

    if (!groupOptional.exists()) {
      setState(() => group = null);
      return;
    }

    setState(() => group = groupOptional.get());
  }

  leaveGroup() async {
    if (group == null) {
      return;
    }

    setState(() => loading = true);
    await groupService.leaveGroup(group!.id);
    Optional<GroupSearch> groupOptional =
        await groupService.searchByName(groupName);
    setState(() => loading = false);

    if (!groupOptional.exists()) {
      setState(() => group = null);
      return;
    }

    setState(() => group = groupOptional.get());
  }
}
