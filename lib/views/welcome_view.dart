import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'You are doing a good thing to use my first flutter app 😄',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
