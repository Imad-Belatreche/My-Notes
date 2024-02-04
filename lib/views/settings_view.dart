import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          backgroundColor: Colors.deepPurple),
      body: const Column(children: [
        Text('Setting 1: '),
        Text('Setting 2: '),
        Text('Setting 3: '),
      ]),
    );
  }
}
