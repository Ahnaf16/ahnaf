import 'dart:developer';

import 'package:flutter/material.dart';

import 'neumorphic_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AHNAF',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool select = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicContainer(
              child: const Text('AHNAF'),
              onTap: () => log('tapped'),
            ),
            const SizedBox(height: 50),
            NeumorphicContainer.selectable(
              selected: select,
              child: const Text('A H N A F'),
              onTap: () {
                select = !select;

                setState(() {});
              },
            ),
            Text(select.toString()),
          ],
        ),
      ),
    );
  }
}
