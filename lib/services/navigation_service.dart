import 'package:flutter/material.dart';

class NavigationService {
  NavigationService(this.context);
  final BuildContext context;

  void next(Widget page) {
    if (!context.mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void replace(Widget page) {
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
