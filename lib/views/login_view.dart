import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

bool isPassword = true;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
              width: 275,
              child: TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(
              width: 275,
              child: TextField(
                controller: _password,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: isPassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  icon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    icon: Icon(
                      isPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (!context.mounted) return;

                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (routes) => false,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Wait'),
                          content: const Text(
                            'Your Email is not verified yet. Check your email for a verification or click to send a new one',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await AuthService.firebase()
                                    .sendEmailVerification();
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'Invalid email',
                  );
                } on UserDisabledAuthException {
                  await showErrorDialog(
                    context,
                    'This account is disabled',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Wrong password',
                  );
                } on InvalidCredentialAuthException {
                  await showErrorDialog(
                    context,
                    'Invalid credential, please check that your email and password are correct',
                  );
                } on NetworkRequestFailedAuthException {
                  await showErrorDialog(
                    context,
                    'Network request failed, please connect to intrnet and try again',
                  );
                } on ChannelErrorAuthException {
                  await showErrorDialog(
                    context,
                    'Please enter your login credentials',
                  );
                } on GeniricAuthException {
                  await showErrorDialog(
                    context,
                    'Oops... an expected error happend, please try again later (Authentication error)',
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registerd yet? Click here to register'),
            ),
          ],
        ),
      ),
    );
  }
}
