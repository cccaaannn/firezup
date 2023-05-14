import 'package:firezup/widgets/create_group_modal.dart';
import 'package:flutter/material.dart';

class EmptyHomePlaceholder extends StatelessWidget {
  const EmptyHomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Join groups by searching, or create a new group by clicking add new button.",
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: () {
              createGroupModal(context);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
            iconSize: 75,
          ),
        ],
      ),
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
}
