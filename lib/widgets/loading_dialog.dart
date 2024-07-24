import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String messageText;

  const LoadingDialog({super.key, required this.messageText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(messageText),
        ],
      ),
    );
  }
}
