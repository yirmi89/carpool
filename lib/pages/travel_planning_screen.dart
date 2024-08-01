import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TravelPlanningScreen extends StatefulWidget {
  final String groupId;

  TravelPlanningScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _TravelPlanningScreenState createState() => _TravelPlanningScreenState();
}

class _TravelPlanningScreenState extends State<TravelPlanningScreen> {
  List<Map<String, dynamic>> schedule = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    final groupDoc = await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get();
    if (groupDoc.exists) {
      setState(() {
        schedule = List<Map<String, dynamic>>.from(groupDoc['schedule']);
        isLoading = false;
      });
    }
  }

  Future<void> _updateSchedule() async {
    await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).update({
      'schedule': schedule,
    });
  }

  void _signUpAsDriver(int index, String driverName) {
    setState(() {
      schedule[index]['driver'] = driverName;
    });
    _updateSchedule();
  }

  void _addChildren(int index, String parentName, int numberOfChildren, String address) {
    setState(() {
      if (schedule[index]['children'] == null) {
        schedule[index]['children'] = [];
      }
      schedule[index]['children'].add({
        'parent': parentName,
        'numberOfChildren': numberOfChildren,
        'from': address,
      });
    });
    _updateSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Planning'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: daysOfWeek.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final daySchedule = schedule.length > index ? schedule[index] : {'driver': '', 'children': []};

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
                        '$day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: daySchedule['driver'].isEmpty
                                ? () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                                if (userDoc.exists) {
                                  final userData = userDoc.data() as Map<String, dynamic>;
                                  final firstName = userData['firstName'] ?? 'Unknown';
                                  _signUpAsDriver(index, firstName);
                                }
                              }
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(daySchedule['driver'].isEmpty ? 'Be the Driver' : 'Driver Assigned'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                                if (userDoc.exists) {
                                  final userData = userDoc.data() as Map<String, dynamic>;
                                  final firstName = userData['firstName'] ?? 'Unknown';
                                  final numberOfChildren = userData['numberOfChildren'] ?? 0;
                                  final address = userData['departureLocation'] ?? 'Unknown';
                                  _addChildren(index, firstName, numberOfChildren, address);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Add Your Children'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Driver: ${daySchedule['driver']}',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
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
                                  children: daySchedule['children'].map<Widget>((child) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Parent: ${child['parent']}'),
                                        SizedBox(height: 8),
                                        Text('Number of Children: ${child['numberOfChildren']}'),
                                        SizedBox(height: 8),
                                        Text('From: ${child['from']}'),
                                        Divider(),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'View Travel Details',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
