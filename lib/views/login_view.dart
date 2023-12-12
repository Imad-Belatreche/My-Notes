import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/welcome_view.dart';
import 'package:page_transition/page_transition.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Container(
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
                      width: 250,
                      child: TextField(
                        controller: _password,
                        autocorrect: false,
                        enableSuggestions: false,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const WelcomeView(),
                                    type: PageTransitionType.fade));
                            print(userCredential);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-credential') {
                              print(
                                  'Invalid Credential (wrong email, password) Or User Not found');
                              print(e.message);
                            } else {
                              print('SOMTHING ELSE HAPPEND');
                              print(e.message);
                            }
                          }
                        },
                        child: const Text('Login'))
                  ],
                ),
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
