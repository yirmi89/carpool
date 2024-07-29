import 'package:flutter/material.dart';

class MyScheduleScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  const MyScheduleScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedule'),
      ),
      body: Center(
        child: Text('My Schedule Screen'),
      ),
    );
  }
}
