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
      backgroundColor: Theme.of(context).primaryColor,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void warning(String message) {
    Flushbar(
      title: 'Warning',
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.yellow.shade600,
      titleColor: Colors.black,
      messageColor: Colors.black,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void error(String message) {
    Flushbar(
      title: 'Error',
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
