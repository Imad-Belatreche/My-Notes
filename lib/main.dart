import 'package:flutter/material.dart';
import 'package:mynotes/home_page.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
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
      body: Center(child: Text('Connection Done Successfully ✅')),
    );
  }
}
