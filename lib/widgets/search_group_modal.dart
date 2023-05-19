import 'package:firezup/data/group_search.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/utils/string_utils.dart';
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
  List<GroupSearch> groupSearchList = List.empty(growable: true);
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
                    groupSearchList.isNotEmpty
                        ? Column(
                            children: groupSearchList.map(
                              (groupSearch) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: Text(
                                        groupSearch.name
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    title: Text(
                                      groupSearch.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "owner: ${StringUtils.splitName(groupSearch.owner)}",
                                    ),
                                    trailing: JoinGroupButton(
                                      groupSearch: groupSearch,
                                      joinGroup: joinGroup,
                                      leaveGroup: leaveGroup,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
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

    List<GroupSearch> groupSearchListTemp =
        await groupService.searchByName(groupName);

    setState(() {
      groupSearchList = groupSearchListTemp;
      loading = false;
    });
  }

  void joinGroup(GroupSearch groupSearch) async {
    setState(() => loading = true);
    await groupService.joinGroup(groupSearch.id);

    List<GroupSearch> groupSearchListTemp =
        await groupService.searchByName(groupName);

    setState(() {
      groupSearchList = groupSearchListTemp;
      loading = false;
    });
  }

  void leaveGroup(GroupSearch groupSearch) async {
    setState(() => loading = true);
    await groupService.leaveGroup(groupSearch.id);

    List<GroupSearch> groupSearchListTemp =
        await groupService.searchByName(groupName);

    setState(() {
      groupSearchList = groupSearchListTemp;
      loading = false;
    });
  }
}
