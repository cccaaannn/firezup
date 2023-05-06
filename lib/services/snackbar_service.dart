import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SnackBarService {
  SnackBarService(this.context);
  final BuildContext context;

  void success(String message) {
    Flushbar(
      title: 'Success',
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
//   void success(String message) {
//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(fontSize: 14),
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 2),
//         action: SnackBarAction(
//           label: "SUCCESS",
//           onPressed: () {},
//           textColor: Colors.white,
//         ),
//       ),
//     );
//   }

  void warning(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: Colors.yellow,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "WARNING",
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  void error(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "ERROR",
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }
}
