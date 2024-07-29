import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carpool/pages/my_groups_screen.dart';
import 'package:carpool/pages/group_page.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:carpool/models/group.dart';
import 'package:carpool/methods/common_methods.dart';

class CreateGroupScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const CreateGroupScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _radiusController = TextEditingController();
  final _commonMethods = CommonMethods();
  final List<String> _days = [];
  final List<String> _hours = [];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(S.of(context).errorLoadingGroups),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).createGroup),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _groupNameController,
                decoration: InputDecoration(labelText: S.of(context).enterGroupName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: "Enter The Group Destination",
                    hintText: "Choose address or school/kindergarten/high school/community center etc.",
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await _commonMethods.getAddresses('', pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _destinationController.text = suggestion;
                },
              ),
              TextFormField(
                controller: _radiusController,
                decoration: InputDecoration(labelText: S.of(context).enterRadius),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a radius';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final group = Group(
                      id: '', // Generate ID here or later on the server side
                      groupName: _groupNameController.text,
                      destinationCity: '', // Not needed as we are using a single field now
                      destinationAddress: _destinationController.text,
                      radius: int.parse(_radiusController.text),
                      days: _days,
                      hours: _hours,
                      creatorId: user.uid,
                    );
                    await FirebaseFirestore.instance.collection('groups').add(group.toMap());

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(S.of(context).success),
                        content: Text(S.of(context).groupNameCreated(group.groupName)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(S.of(context).ok),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text(S.of(context).createGroup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
