import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpool/models/group.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Groups')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Group> groups = snapshot.data!.docs.map((doc) {
            return Group.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              Group group = groups[index];
              return ListTile(
                title: Text(group.name), // Changed from group.groupName to group.name
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Schedule: ${group.schedule}'), // Ensure schedule property exists
                    Text('Vehicle Info: ${group.vehicleInfo}'), // Ensure vehicleInfo property exists
                  ],
                ),
                onTap: () {
                  // Navigate to group details page
                },
              );
            },
          );
        },
      ),
    );
  }
}
