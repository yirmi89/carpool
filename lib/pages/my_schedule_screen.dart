import 'package:flutter/material.dart';

class MyScheduleScreen extends StatelessWidget {
  const MyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
      ),
      body: const Center(
        child: Text('My Schedule Screen'),
      ),
    );
  }
}
