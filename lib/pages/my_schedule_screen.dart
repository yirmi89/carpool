import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyScheduleScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  MyScheduleScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedule'),
      ),
      body: user != null
          ? StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No schedule found'));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final schedule = userData['schedule'] ?? {};

          return ListView.builder(
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final day = schedule.keys.elementAt(index);
              final details = schedule[day];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(day),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Driver: ${details['driver']}'),
                      ...details['children'].map<Widget>((child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${child['name']}'),
                            Text('Number of children: ${child['childrenCount']}'),
                            Text('Address: ${child['address']}'),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      )
          : Center(child: Text('Please log in')),
    );
  }
}
