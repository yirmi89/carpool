import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carpool/pages/my_groups_screen.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:carpool/models/group.dart';
import 'package:carpool/methods/common_methods.dart';

class CreateGroupScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  CreateGroupScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final CommonMethods commonMethods = CommonMethods();
    final Color primaryColor = const Color(0xFF1C4B93); // Adjusted color from the carpool logo

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).createGroup),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    labelText: S.of(context).enterGroupName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: S.of(context).rideGroupDestination,
                      hintText: S.of(context).chooseAddress,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await commonMethods.getAddresses(_destinationController.text, pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _destinationController.text = suggestion.toString();
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _radiusController,
                  decoration: InputDecoration(
                    labelText: S.of(context).maxDistanceFromDestination,
                    hintText: S.of(context).enterMaxDistance,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (user != null) {
                      final group = Group(
                        id: '',
                        groupName: _groupNameController.text,
                        destinationCity: '',
                        destinationAddress: _destinationController.text,
                        radius: int.parse(_radiusController.text),
                        days: [],
                        hours: [],
                        creatorId: user.uid,
                      );

                      await FirebaseFirestore.instance
                          .collection('groups')
                          .add(group.toMap());

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(S.of(context).success),
                          content: Text(S.of(context).groupNameCreated(group.groupName)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyGroupsScreen(onLocaleChange: widget.onLocaleChange)),
                                      (route) => false,
                                );
                              },
                              child: Text(S.of(context).goToGroupPage),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(S.of(context).close),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    S.of(context).createGroup,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
