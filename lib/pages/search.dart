import 'package:flutter/material.dart';

class JoinGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List of Groups:',
              style: TextStyle(fontSize: 18),
            ),
            // Implement logic to display list of groups
          ],
        ),
      ),
    );
  }
}
