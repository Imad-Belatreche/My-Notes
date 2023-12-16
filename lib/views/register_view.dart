import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 250,
              child: TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
            ),
            SizedBox(
              height: 80,
              width: 250,
              child: TextField(
                controller: _password,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/verify/', (_) => false);

                    log(userCredential.toString());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      log('Email is already in use.');
                      log(e.message.toString());
                    } else if (e.code == 'weak-password') {
                      log('Weak password.');
                      log(e.message.toString());
                    } else if (e.code == 'invalid-email') {
                      log('Invalid Email');
                      log(e.message.toString());
                    } else {
                      log('SOMTHING BAD HAPPEND');
                      log(e.message.toString());
                      log(e.code.toString());
                    }
                  }
                },
                child: const Text('Register')),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
                },
                child: const Text('Already have an account? Login here'))
          ],
        ),
      ),
    );
  }
}
