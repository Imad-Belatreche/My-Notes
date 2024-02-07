import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify your email to continue'),
        ),
        body: Column(
          children: [
            const Text(
                " We'v sent you an email verification. Please open it to verify your account"),
            const Text(
                "If you haven't received the verification email. Click here"),
            TextButton(
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(const AuthEventSendEmailVerification());
              },
              child: const Text('Send email verification'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Restart'),
            )
          ],
        ),
      ),
    );
  }
}
