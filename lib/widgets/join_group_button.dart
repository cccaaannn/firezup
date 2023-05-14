import 'package:firezup/data/group_search.dart';
import 'package:flutter/material.dart';

class JoinGroupButton extends StatefulWidget {
  final GroupSearch? groupSearch;
  final Function joinGroup;
  final Function leaveGroup;

  const JoinGroupButton(
      {super.key,
      required this.groupSearch,
      required this.joinGroup,
      required this.leaveGroup});

  @override
  State<JoinGroupButton> createState() => _JoinGroupButtonState();
}

class _JoinGroupButtonState extends State<JoinGroupButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.groupSearch!.joined
          ? () => widget.joinGroup()
          : () => widget.leaveGroup(),
      style: widget.groupSearch!.joined
          ? OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            )
          : OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1,
              ),
            ),
      child: Text(
        widget.groupSearch!.joined ? "Join" : "Leave",
        style: widget.groupSearch!.joined
            ? TextStyle(
                color: Theme.of(context).primaryColor,
              )
            : TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
      ),
    );
  }
}
