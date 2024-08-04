import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:intl/intl.dart';

class TravelPlanningScreen extends StatefulWidget {
  final String groupId;

  TravelPlanningScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _TravelPlanningScreenState createState() => _TravelPlanningScreenState();
}

class _TravelPlanningScreenState extends State<TravelPlanningScreen> {
  List<Map<String, dynamic>> schedule = [];
  bool isLoading = true;
  bool isRoundTrip = false;
  String userFirstName = '';
  String userAddress = '';
  int userChildren = 1;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
    _fetchUserData();
  }

  Future<void> _fetchSchedule() async {
    final groupDoc = await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get();
    if (groupDoc.exists) {
      setState(() {
        schedule = List<Map<String, dynamic>>.from(groupDoc['schedule']);
        isRoundTrip = groupDoc['roundTrip'] ?? false;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          final userData = userDoc.data() as Map<String, dynamic>;
          userFirstName = userData['firstName'] ?? 'Unknown';
          userAddress = userData['departureLocation'] ?? '';
          userChildren = userData['children'] ?? 1;
        });
      }
    }
  }

  Future<void> _updateSchedule() async {
    await FirebaseFirestore.instance.collection('groups')
        .doc(widget.groupId)
        .update({
      'schedule': schedule,
    });
  }

  void _signUpAsDriver(int index, String driverName, {required bool isReturning}) {
    setState(() {
      if (isReturning) {
        schedule[index]['driverReturning'] = driverName;
      } else {
        schedule[index]['driverGoing'] = driverName;
      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).travelPlanning),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: schedule
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key;
            final daySchedule = entry.value;

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
                        daySchedule['date'],
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
                            onPressed: daySchedule['driverGoing'].isEmpty
                                ? () async {
                              _signUpAsDriver(index, userFirstName, isReturning: false);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(daySchedule['driverGoing'].isEmpty ? S.of(context).driveGoing : S.of(context).driverGoing(daySchedule['driverGoing'])),
                          ),
                          if (isRoundTrip)
                            ElevatedButton(
                              onPressed: daySchedule['driverReturning'].isEmpty
                                  ? () async {
                                _signUpAsDriver(index, userFirstName, isReturning: true);
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(daySchedule['driverReturning'].isEmpty ? S.of(context).driveReturning : S.of(context).driverReturning(daySchedule['driverReturning'])),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        S.of(context).driverGoing(daySchedule['driverGoing']),
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      if (isRoundTrip)
                        Text(
                          S.of(context).driverReturning(daySchedule['driverReturning']),
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _addChildrenDialog(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(S.of(context).addYourChildren),
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
                                        Text(S.of(context).parent(child['parent'])),
                                        SizedBox(height: 8),
                                        Text(S.of(context).numberOfChildrenCount(child['numberOfChildren'])),
                                        SizedBox(height: 8),
                                        Text(S.of(context).from(child['from'].toString())), // Fixed here
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
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          S.of(context).viewTravelDetails,
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

  void _addChildrenDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController numberOfChildrenController = TextEditingController(text: userChildren.toString());
        final TextEditingController addressController = TextEditingController(text: userAddress);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(S.of(context).addYourChildren),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: userFirstName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: numberOfChildrenController,
                decoration: InputDecoration(
                  labelText: S.of(context).numberOfChildren,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: S.of(context).fromLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).close),
            ),
            TextButton(
              onPressed: () {
                _addChildren(
                  index,
                  userFirstName,
                  int.parse(numberOfChildrenController.text.trim()),
                  addressController.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).add),
            ),
          ],
        );
      },
    );
  }
}
