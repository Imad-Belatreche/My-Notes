import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGeniricDialog(
    context: context,
    title: 'Password reset',
    content:
        'We have sent you a password reset link. Please check your email for more information.',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
