import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/home_page_view.dart';
import 'package:mynotes/views/email_verification_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        emailVerifyRoute: (context) => const EmailVerificationView(),
        settingsRoute: (context) => const SettingsView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
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
