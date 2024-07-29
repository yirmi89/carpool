import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/models/group.dart';
import 'package:carpool/generated/l10n.dart';
import 'group_page.dart';

class MyGroupsScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  MyGroupsScreen({required this.onLocaleChange});

  @override
  _MyGroupsScreenState createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).myGroups),
          actions: [
            PopupMenuButton<Locale>(
              onSelected: widget.onLocaleChange,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                PopupMenuItem(
                  value: Locale('he'),
                  child: Text('עברית'),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: Text(S.of(context).errorLoadingGroups),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myGroups),
        actions: [
          PopupMenuButton<Locale>(
            onSelected: widget.onLocaleChange,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              PopupMenuItem(
                value: Locale('he'),
                child: Text('עברית'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('groups').where('creatorId', isEqualTo: user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(S.of(context).noGroups));
          }

          final groups = snapshot.data!.docs.map((doc) => Group.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                title: Text(group.groupName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupPage(groupId: group.id, groupName: group.groupName, onLocaleChange: widget.onLocaleChange),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
