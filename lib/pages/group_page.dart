import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:carpool/pages/travel_planning_screen.dart';
import 'package:carpool/pages/chat_screen.dart';
import 'package:carpool/pages/home_screen.dart';

class GroupPage extends StatefulWidget {
  final String groupId;
  final void Function(Locale) onLocaleChange;

  GroupPage({Key? key, required this.groupId, required this.onLocaleChange}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late String _groupName = '';
  late DocumentSnapshot _groupSnapshot;
  bool _loading = true;
  int participantsCount = 0;
  List<String> participantIds = [];

  @override
  void initState() {
    super.initState();
    _fetchGroupDetails();
  }

  Future<void> _fetchGroupDetails() async {
    final groupDoc = await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get();
    if (groupDoc.exists) {
      setState(() {
        _groupSnapshot = groupDoc;
        _groupName = _groupSnapshot['groupName'];
        participantIds = List<String>.from(_groupSnapshot['participants']);
        participantsCount = participantIds.length;
        _loading = false;
      });
      print("Participant IDs: $participantIds");
    }
  }

  Future<void> _leaveGroup() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final int childrenCount = userData['numberOfChildren'] ?? 0;

        // Remove user from group's participants
        await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).update({
          'participants': FieldValue.arrayRemove([user.uid])
        });

        // Remove group from user's list
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'groups': FieldValue.arrayRemove([widget.groupId])
        });

        // Update the number of places left in the group
        await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).update({
          'placesLeft': FieldValue.increment(childrenCount)
        });

        // Remove related rides from user's schedule
        final userScheduleRef = FirebaseFirestore.instance.collection('schedules').doc(user.uid);
        final userScheduleDoc = await userScheduleRef.get();
        if (userScheduleDoc.exists) {
          final userScheduleData = userScheduleDoc.data() as Map<String, dynamic>;
          final updatedSchedule = userScheduleData['schedule'].where((ride) => ride['groupId'] != widget.groupId).toList();
          await userScheduleRef.update({'schedule': updatedSchedule});
        }

        // Send a message to the group chat
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .collection('messages')
            .add({
          'senderId': user.uid,
          'senderName': user.displayName ?? 'Anonymous',
          'text': S.of(context).leaveGroupDetailedMessage(_groupName),
          'timestamp': Timestamp.now(),
        });

        // Send a notification
        await FirebaseFirestore.instance.collection('notifications').add({
          'groupId': widget.groupId,
          'message': S.of(context).leaveGroupNotification(user.displayName ?? 'Anonymous', _groupName),
          'timestamp': Timestamp.now(),
        });

        setState(() {
          participantIds.remove(user.uid);
          participantsCount--;
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).leaveGroupMessage(_groupName)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(onLocaleChange: widget.onLocaleChange)),
                          (route) => false,
                    );
                  },
                  child: Text(S.of(context).returnToHomeScreen),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _loading ? const Text('') : Text(_groupName, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: primaryColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _showParticipants(context),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Column(
                            children: [
                              Text(
                                participantsCount.toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                S.of(context).participants,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridButton(Icons.calendar_today, S.of(context).travelPlanning, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelPlanningScreen(groupId: widget.groupId),
                      ),
                    );
                  }),
                  _buildGridButton(Icons.chat, S.of(context).groupChat, _showGroupChat),
                  _buildGridButton(Icons.location_on, S.of(context).showRideLiveLocation, () {}),
                  _buildGridButton(
                    Icons.exit_to_app,
                    S.of(context).leaveThisRideGroup,
                    _confirmLeaveGroup,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(IconData icon, String label, VoidCallback onPressed,
      {Color textColor = const Color(0xFF1C4B93), Color iconColor = const Color(0xFF1C4B93)}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: iconColor),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: textColor)),
          ],
        ),
      ),
    );
  }

  void _showParticipants(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).participants),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: participantIds.isEmpty
                ? Text(S.of(context).noParticipantsFound)
                : FutureBuilder<List<String>>(
              future: _getParticipantFirstNames(participantIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(S.of(context).somethingWentWrong);
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text(S.of(context).noParticipantsFound);
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _getParticipantFirstNames(List<String> participantIds) async {
    List<String> firstNames = [];
    for (String id in participantIds) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        print("User Data for $id: $data");
        firstNames.add(data['firstName'] ?? 'Unknown');
      }
    }
    return firstNames;
  }

  void _showGroupChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChatScreen(groupId: widget.groupId),
      ),
    );
  }

  void _confirmLeaveGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).confirmLeaveGroup),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showLeaveGroupConfirmation();
              },
              child: Text(S.of(context).yes),
            ),
          ],
        );
      },
    );
  }

  void _showLeaveGroupConfirmation() {
    _leaveGroup();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).leaveGroupMessage(_groupName)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(onLocaleChange: widget.onLocaleChange)),
                      (route) => false,
                );
              },
              child: Text(S.of(context).returnToHomeScreen),
            ),
          ],
        );
      },
    );
  }
}
