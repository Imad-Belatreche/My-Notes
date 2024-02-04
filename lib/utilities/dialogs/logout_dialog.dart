import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGeniricDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure about that ?',
    optionBuilder: () => {
      'Log out': true,
      'Close': false,
    },
  ).then((value) => value ?? false);
}
