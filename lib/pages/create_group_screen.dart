import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carpool/methods/common_methods.dart';
import 'package:intl/intl.dart';
import '../models/group.dart';
import 'package:carpool/pages/home_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  CreateGroupScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _maxParticipantsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isRoundTrip = false;

  @override
  void initState() {
    super.initState();
    _loadUserChildren();
  }

  Future<void> _loadUserChildren() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('numberOfChildren')) {
          _childrenController.text = data['numberOfChildren'].toString();
        }
      }
    }
  }

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      final groupName = _groupNameController.text.trim();
      final destination = _destinationController.text.trim();
      final radius = int.parse(_radiusController.text.trim());
      final maxParticipants = int.parse(_maxParticipantsController.text.trim());
      final childrenToAdd = int.parse(_childrenController.text.trim());
      final remainingParticipants = maxParticipants - childrenToAdd;
      final startDate = DateFormat('dd.MM.yyyy').parse(_startDateController.text.trim());
      final endDate = DateFormat('dd.MM.yyyy').parse(_endDateController.text.trim());

      final user = _auth.currentUser;
      if (user != null) {
        final List<Map<String, dynamic>> initialSchedule = [];
        DateTime currentDate = startDate;
        while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
          initialSchedule.add({
            'date': DateFormat('EEEE-dd.MM.yyyy').format(currentDate),
            'driverGoing': '',
            'driverReturning': '',
            'children': [],
          });
          currentDate = currentDate.add(Duration(days: 1));
        }

        final group = Group(
          id: '',
          groupName: groupName,
          destinationAddress: destination,
          radius: radius,
          creatorId: user.uid,
          maxUsers: maxParticipants,
          currentUsers: childrenToAdd,
          remainingParticipants: remainingParticipants,
          participants: [user.uid],
          schedule: initialSchedule,
          startDate: startDate,
          endDate: endDate,
          roundTrip: _isRoundTrip,
        );

        final docRef = await FirebaseFirestore.instance.collection('groups').add(group.toMap());
        final groupId = docRef.id;

        // Add the group to the user's groups list
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'groups': FieldValue.arrayUnion([groupId]),
        });

        // Clear form fields
        _groupNameController.clear();
        _destinationController.clear();
        _radiusController.clear();
        _maxParticipantsController.clear();
        _childrenController.clear();
        _startDateController.clear();
        _endDateController.clear();

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
                    MaterialPageRoute(builder: (context) => HomeScreen(onLocaleChange: widget.onLocaleChange)),
                        (route) => false,
                  );
                },
                child: Text(S.of(context).close),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final CommonMethods commonMethods = CommonMethods();
    final Color primaryColor = const Color(0xFF1C4B93); // Adjusted color from the carpool logo

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).createGroup,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set the arrow color to white
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      labelText: S.of(context).enterGroupName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a destination';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _radiusController,
                    decoration: InputDecoration(
                      labelText: S.of(context).maxDistanceFromDestination,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a radius';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _maxParticipantsController,
                    decoration: InputDecoration(
                      labelText: S.of(context).maxParticipants,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of participants';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _childrenController,
                    decoration: InputDecoration(
                      labelText: S.of(context).childrenToAdd,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of children';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      labelText: S.of(context).startDate,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _startDateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a start date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: S.of(context).endDate,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _endDateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an end date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text(S.of(context).roundTrip),
                    value: _isRoundTrip,
                    onChanged: (newValue) {
                      setState(() {
                        _isRoundTrip = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createGroup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      S.of(context).createGroup,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
