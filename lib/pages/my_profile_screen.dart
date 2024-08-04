import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carpool/methods/common_methods.dart';

class MyProfileScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  MyProfileScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CommonMethods commonMethods = CommonMethods();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _firstNameController.text = userData['firstName'] ?? '';
        _lastNameController.text = userData['lastName'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _departureController.text = userData['departureLocation'] ?? '';
        _childrenController.text = userData['numberOfChildren'].toString() ?? '';
      });
    }
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'departureLocation': _departureController.text,
        'numberOfChildren': int.tryParse(_childrenController.text) ?? 0,
      });

      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myDetails),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: S.of(context).firstName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: S.of(context).lastName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                enabled: false, // Email should not be editable
                decoration: InputDecoration(
                  labelText: S.of(context).email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _departureController,
                  enabled: _isEditing,
                  decoration: InputDecoration(
                    labelText: S.of(context).departureLocation,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await commonMethods.getAddresses(_departureController.text, pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.toString()),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _departureController.text = suggestion.toString();
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _childrenController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: S.of(context).numberOfChildrenLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_isEditing) {
                    _saveUserData();
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
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
                  _isEditing ? S.of(context).saveDetails : S.of(context).editDetails,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
