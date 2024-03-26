import 'package:flutter/material.dart';

class RideDetailsScreen extends StatefulWidget {
  @override
  _RideDetailsScreenState createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  bool isAdmin = false; // Variable to hold the state of the checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Ride Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of Seats:',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(),
            SizedBox(height: 20),
            Text(
              'Number of Children:',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(),
            SizedBox(height: 20),
            Text(
              'Preferred Ride Day:',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(),
            SizedBox(height: 20),
            Text(
              'Willingness to be an Administrator:',
              style: TextStyle(fontSize: 18),
            ),
            CheckboxListTile(
              title: Text('Yes'),
              value: isAdmin, // Use the variable to hold the state
              onChanged: (value) {
                setState(() {
                  isAdmin = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to save ride details
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
