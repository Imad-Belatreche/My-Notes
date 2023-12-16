import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/welcome_view.dart';

enum MenuAction { logout, settings }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Main UI',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<MenuAction>(
            iconColor: Colors.white,
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (_) => false);
                  }
                case MenuAction.settings:
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/settings/', (_) => false);
                default:
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out')),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text('Settings'),
                )
              ];
            },
          ),
        ],
      ),
      body: const WelcomeView(),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to Log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
