import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/generated/l10n.dart';

class MyScheduleScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  MyScheduleScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _MyScheduleScreenState createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  List<Map<String, dynamic>> schedule = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final groups = userData['groups'] ?? [];

        for (var groupId in groups) {
          final groupDoc = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
          if (groupDoc.exists) {
            final groupData = groupDoc.data() as Map<String, dynamic>;
            for (var i = 0; i < groupData['schedule'].length; i++) {
              if (groupData['schedule'][i]['driverGoing'] == userData['firstName']) {
                schedule.add({
                  'day': groupData['schedule'][i]['date'],
                  'groupName': groupData['groupName'],
                  'children': groupData['schedule'][i]['children'],
                  'groupId': groupId,
                  'type': 'going',
                });
              }
              if (groupData['schedule'][i]['driverReturning'] == userData['firstName']) {
                schedule.add({
                  'day': groupData['schedule'][i]['date'],
                  'groupName': groupData['groupName'],
                  'children': groupData['schedule'][i]['children'],
                  'groupId': groupId,
                  'type': 'returning',
                });
              }
            }
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _cancelRide(Map<String, dynamic> ride) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).confirmCancelRide),
          content: Text(S.of(context).cancellationText(ride['day'])),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).no),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Remove the ride from the user's schedule
                  final userScheduleRef = FirebaseFirestore.instance.collection('schedules').doc(user.uid);
                  final userScheduleDoc = await userScheduleRef.get();
                  if (userScheduleDoc.exists) {
                    final userScheduleData = userScheduleDoc.data() as Map<String, dynamic>;
                    final updatedSchedule = userScheduleData['schedule']
                        .where((r) => !(r['groupId'] == ride['groupId'] && r['date'] == ride['day']))
                        .toList();
                    await userScheduleRef.update({'schedule': updatedSchedule});
                  }

                  // Send cancellation message in the group chat
                  await FirebaseFirestore.instance
                      .collection('groups')
                      .doc(ride['groupId'])
                      .collection('messages')
                      .add({
                    'senderId': user.uid,
                    'senderName': user.displayName ?? 'Anonymous',
                    'text': S.of(context).cancelRideNotification(user.displayName ?? 'Anonymous'),
                    'timestamp': Timestamp.now(),
                  });

                  // Show the second confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(S.of(context).updateCancellation),
                        content: Text(S.of(context).cancellationMessage(ride['day'])),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(S.of(context).ok),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(S.of(context).yes),
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
        title: Text(
          S.of(context).mySchedule,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFF1C4B93),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final daySchedule = schedule[index];
                final day = daySchedule['day'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$day - ${daySchedule['groupName']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              _showPassengerList(context, daySchedule['children']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(S.of(context).viewTravelDetails),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _cancelRide(daySchedule);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(S.of(context).cancelRide),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPassengerList(BuildContext context, List<dynamic> children) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.map<Widget>((child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).parent(child['parent'])),
                  SizedBox(height: 8),
                  Text(S.of(context).numberOfChildrenCount(child['numberOfChildren'])),
                  SizedBox(height: 8),
                  Text(S.of(context).from(child['from'])),
                  Divider(),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).close),
            ),
            TextButton(
              onPressed: () {
                // Implement "Show on the map" functionality here
              },
              child: Text(S.of(context).showOnMap),
            ),
          ],
        );
      },
    );
  }
}
