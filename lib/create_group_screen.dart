import 'package:flutter/material.dart';
import 'dart:math';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String groupName = '';
  String? groupType = '';

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
            RadioListTile(
              title: Text('Up to 5 seats\n(One ride a week)'),
              value: 'Cars with up to 5 seats',
              groupValue: groupType,
              onChanged: (value) {
                setState(() {
                  groupType = value;
                });
              },
              activeColor: Colors.blue, // Set active color when selected
            ),
            RadioListTile(
              title: Text('6+ seats\n(Two rides a week)'),
              value: 'Cars with 6+ seats',
              groupValue: groupType,
              onChanged: (value) {
                setState(() {
                  groupType = value;
                });
              },
              activeColor: Colors.blue, // Set active color when selected
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Generate random id with 5 numbers
                Random random = Random();
                int groupId = random.nextInt(90000) + 10000;

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
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Create Ride Group'),
            ),
          ],
        ),
      ),
    );
  }
}
