import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:carpool/models/message.dart';  // Import your Message model

class GroupChatScreen extends StatefulWidget {
  final String groupId;

  GroupChatScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendMessage() async {
    final user = _auth.currentUser;
    if (user != null && _messageController.text.isNotEmpty) {
      final message = Message(
        senderId: user.uid,
        senderName: user.displayName ?? 'Anonymous',
        text: _messageController.text,
        timestamp: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('messages')
          .add(message.toMap());

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C4B93),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs.map((doc) {
                  final message = Message.fromMap(doc.data() as Map<String, dynamic>);
                  final messageTime = message.timestamp.toDate();
                  final now = DateTime.now();
                  final messageDate = DateFormat.yMMMd().format(messageTime);
                  final isToday = messageTime.year == now.year &&
                      messageTime.month == now.month &&
                      messageTime.day == now.day;

                  final timeString = isToday
                      ? 'Today at ${DateFormat.jm().format(messageTime)}'
                      : '$messageDate at ${DateFormat.jm().format(messageTime)}';

                  return ListTile(
                    title: Text(message.senderName),
                    subtitle: Text(message.text),
                    trailing: Text(timeString),
                  );
                }).toList();

                return ListView(
                  reverse: true,
                  children: messages,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
