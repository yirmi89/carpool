import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/generated/l10n.dart';
import 'group_chat_screen.dart';
import 'travel_planning_screen.dart';

class GroupPage extends StatefulWidget {
  final String groupId;

  GroupPage({Key? key, required this.groupId}) : super(key: key);

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
      // Debug statement to print the participant IDs fetched from Firestore
      print("Participant IDs: $participantIds");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _loading ? Text('') : Text(_groupName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: primaryColor,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
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
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                S.of(context).participants,
                                style: TextStyle(
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
                physics: NeverScrollableScrollPhysics(),
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
                  _buildGridButton(Icons.exit_to_app, S.of(context).leaveThisRideGroup, _leaveGroup),
                  _buildGridButton(Icons.cancel, S.of(context).cancelRide, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(IconData icon, String label, VoidCallback onPressed) {
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
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: const Color(0xFF1C4B93)),
            SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: const Color(0xFF1C4B93))),
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
                icon: Icon(Icons.close),
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
                  return CircularProgressIndicator();
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
        // Debug statement to print user data for each participant ID
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

  void _leaveGroup() {
    // Implement the leave group feature
  }
}
