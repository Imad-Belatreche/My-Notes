import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'User not found',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'Invalid email',
            );
          } else if (state.exception is UserDisabledAuthException) {
            await showErrorDialog(
              context,
              'This account is disabled',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              'Wrong password',
            );
          } else if (state.exception is InvalidCredentialAuthException) {
            await showErrorDialog(
              context,
              'Invalid credential, please check that your email and password are correct',
            );
          } else if (state.exception is NetworkRequestFailedAuthException) {
            await showErrorDialog(
              context,
              'Network request failed, please connect to intrnet and try again',
            );
          } else if (state.exception is ChannelErrorAuthException) {
            await showErrorDialog(
              context,
              'Please enter your login credentials',
            );
          } else if (state.exception is GeniricAuthException) {
            await showErrorDialog(
              context,
              'Oops... an expected error happend, please try again later (Authentication error)',
            );
          }
        }
      },
      child: Scaffold(
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
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email: email,
                          password: password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text('Not registerd yet? Click here to register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
