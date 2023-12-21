import 'package:flutter/material.dart';
import 'package:mynotes/views/home_page_view.dart';
import 'package:mynotes/views/email_verification_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/settings_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'My Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
        '/verify/': (context) => const EmailVerificationView(),
        '/settings/': (context) => const SettingsView()
      },
    ),
  );
}

class ConnectonDone extends StatefulWidget {
  const ConnectonDone({super.key});

  @override
  State<ConnectonDone> createState() => _ConnectonDoneState();
}

class _ConnectonDoneState extends State<ConnectonDone> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'Connection Done Successfully',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'JetBrains Mono',
          fontSize: 25,
        ),
      )),
      backgroundColor: Colors.deepPurple,
    );
  }
}
