import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  if (!context.mounted) return;

                  if (user?.emailVerified ?? false) {
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
                                await FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (!context.mounted) return;
                  if (e.code == 'invalid-email') {
                    await showErrorDialog(
                      context,
                      'Invalid email',
                    );
                  } else if (e.code == 'user-disabled') {
                    await showErrorDialog(
                      context,
                      'This account is disabled',
                    );
                  } else if (e.code == 'user-not-found') {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } else if (e.code == 'wrong-password') {
                    await showErrorDialog(
                      context,
                      'Wrong password',
                    );
                  } else if (e.code == 'invalid-credential') {
                    await showErrorDialog(
                      context,
                      'Invalid credential, please check that your email and password are correct',
                    );
                  } else if (e.code == 'network-request-failed') {
                    await showErrorDialog(
                      context,
                      'Network request failed, please connect to intrnet and try again',
                    );
                  } else if (e.code == 'channel-error') {
                    await showErrorDialog(
                      context,
                      'Please enter your login credentials',
                    );
                  } else {
                    await showErrorDialog(
                      context,
                      'Oops... an expected error happend, please try again later (${e.code})',
                    );
                    log(e.code);
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                  log(e.toString());
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
