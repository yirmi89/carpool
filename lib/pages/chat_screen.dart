import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String groupId;

  ChatScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Center(
        child: Text("Chat for group: $groupId"),
      ),
    );
  }
}
