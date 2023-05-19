import 'package:flutter/material.dart';

class SelectionModal extends StatelessWidget {
  final String header;
  final String description;
  final void Function() onAccept;
  final void Function() onDecline;

  const SelectionModal(
      {super.key,
      required this.onAccept,
      required this.onDecline,
      required this.header,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(header),
      content: Text(description),
      actions: [
        IconButton(
          onPressed: onDecline,
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: onAccept,
          icon: Icon(
            Icons.done_outline,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
