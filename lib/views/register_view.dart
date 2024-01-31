import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

bool isPassword = true;

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
      appBar: AppBar(
        title: const Text('Register'),
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
                  icon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(
              height: 75,
              width: 275,
              child: TextField(
                controller: _password,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: isPassword,
                decoration: InputDecoration(
                  icon: const Icon(Icons.password),
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
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
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamed(
                      emailVerifyRoute,
                    );
                    
                    await AuthService.firebase().sendEmailVerification();
                    if (!context.mounted) return;
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(
                      context,
                      'Email already in use',
                    );
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Weak password',
                    );
                  } on ChannelErrorAuthException {
                    await showErrorDialog(
                      context,
                      'Please enter your login credentials',
                    );
                  } on InvalidEmailAuthException {
                    await showErrorDialog(
                      context,
                      'Invalid email',
                    );
                  } on GeniricAuthException {
                    await showErrorDialog(
                      context,
                      'Oops... an expected error happend, please try again later (Failed to register)',
                    );
                  }
                },
                child: const Text('Register')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already have an account? Login here'),
            )
          ],
        ),
      ),
    );
  }
}
