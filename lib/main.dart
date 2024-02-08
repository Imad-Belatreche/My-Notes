import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/home_page_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/settings_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'My Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'FiraCode',
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
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
        ),
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
}
