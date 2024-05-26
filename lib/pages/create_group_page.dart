import 'dart:math';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  String groupName = '';
  String? groupType;
  int groupId = 0;

  // Function to generate a random group ID
  void generateGroupId() {
    Random random = Random();
    setState(() {
      groupId = random.nextInt(90000) + 10000;
    });
  }

  // Function to show the pop-up window with the generated group ID
  void showGroupIdPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Group Created'),
          content: Text('Group ID: $groupId'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Name:',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  groupName = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Group Type:',
              style: TextStyle(fontSize: 18),
            ),
            ListTile(
              title: Text('Up to 5 seats (One ride a week)'),
              leading: Radio<String>(
                value: 'Up to 5 seats (One ride a week)',
                groupValue: groupType,
                onChanged: (String? value) {
                  setState(() {
                    groupType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('6+ seats (Two rides a week)'),
              leading: Radio<String>(
                value: '6+ seats (Two rides a week)',
                groupValue: groupType,
                onChanged: (String? value) {
                  setState(() {
                    groupType = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                generateGroupId();
                showGroupIdPopup();
              },
              child: Text('Create Ride Group'),
            ),
          ],
        ),
      ),
    );
  }
}
