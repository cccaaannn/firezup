import 'package:firezup/data/group.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/group_service.dart';
import 'package:firezup/services/snackbar_service.dart';
import 'package:firezup/utils/validation_utils.dart';
import 'package:firezup/widgets/loading.dart';
import 'package:firezup/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class CreateGroupModal extends StatefulWidget {
  const CreateGroupModal({super.key});

  @override
  State<CreateGroupModal> createState() => _CreateGroupModalState();
}

class _CreateGroupModalState extends State<CreateGroupModal> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String groupName = "";

  GroupService groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: ((context, setState) {
        return AlertDialog(
          title: const Text(
            "Create a group",
            textAlign: TextAlign.left,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              loading
                  ? const Loading()
                  : Form(
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
                if (!formKey.currentState!.validate()) {
                  return;
                }

                setState(() => loading = true);
                Optional<Group> groupOptional =
                    await groupService.createGroup(groupName);
                setState(() => loading = false);

                if (!groupOptional.exists()) {
                  SnackBarService(context).error("Something went wrong");
                  return;
                }

                Navigator.of(context).pop();

                SnackBarService(context)
                    .success("Group ${groupOptional.get()!.name} created");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text("Create"),
            )
          ],
        );
      }),
    );
  }
}
