import 'package:flutter/material.dart';

import 'const.dart';
import 'creative_kit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const CreativeKitScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'Creative Kit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login Kit',
            ),
          ],
        ),
      ),
    );
  }
}
