import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpool/models/group.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _availableSeatsController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _vehicleInfoController = TextEditingController();
  final List<String> _selectedDays = [];

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          Group newGroup = Group(
            id: _firestore.collection('groups').doc().id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            availableSeats: int.parse(_availableSeatsController.text.trim()),
            drivingDays: _selectedDays,
            createdBy: user.uid,
            schedule: _scheduleController.text.trim(),
            vehicleInfo: _vehicleInfoController.text.trim(),
          );

          await _firestore.collection('groups').doc(newGroup.id).set(newGroup.toMap());

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Group created successfully')),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _availableSeatsController,
                decoration: const InputDecoration(labelText: 'Available Seats'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of available seats';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _scheduleController,
                decoration: const InputDecoration(labelText: 'Schedule'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the schedule';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleInfoController,
                decoration: const InputDecoration(labelText: 'Vehicle Info'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the vehicle info';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Select Driving Days'),
              Wrap(
                spacing: 8.0,
                children: _days.map((day) {
                  return FilterChip(
                    label: Text(day),
                    selected: _selectedDays.contains(day),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createGroup,
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
