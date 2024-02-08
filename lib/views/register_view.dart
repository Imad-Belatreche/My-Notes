import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

bool isPassword = true;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordConfirm;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordConfirm = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'Email already in use',
            );
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'Weak password',
            );
          } else if (state.exception is ChannelErrorAuthException) {
            await showErrorDialog(
              context,
              'Please enter your login credentials',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'Invalid email',
            );
          } else if (state.exception is GeniricAuthException) {
            await showErrorDialog(
              context,
              'Oops... an expected error happend, please try again later (Failed to register)',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  10,
                  15,
                  10,
                  10,
                ),
                child: Text(
                  'Enter you credentials to create a new account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      wordSpacing: -4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  10,
                ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  10,
                ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  56,
                  2,
                  16,
                  10,
                ),
                child: TextField(
                  controller: _passwordConfirm,
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: isPassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm password',
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    if (_password.text == _passwordConfirm.text) {
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventRegister(
                              email,
                              password,
                            ),
                          );
                    } else {
                      _password.clear();
                      _passwordConfirm.clear();
                      showGeniricDialog(
                        context: context,
                        title: 'Register',
                        content: 'Please confirm your password',
                        optionBuilder: () => {
                          'OK': null,
                        },
                      );
                    }
                  },
                  child: const Text('Register')),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text('Already have an account? Login here'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
