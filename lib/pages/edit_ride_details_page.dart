import 'package:flutter/material.dart';

class EditRideDetailsPage extends StatefulWidget {
  const EditRideDetailsPage({Key? key}) : super(key: key);

  @override
  State<EditRideDetailsPage> createState() => _EditRideDetailsPageState();
}

class _EditRideDetailsPageState extends State<EditRideDetailsPage> {
  int numberOfSeats = 0;
  int numberOfChildren = 0;
  String preferredRideDay = '';
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Ride Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of Seats:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  numberOfSeats = int.tryParse(value) ?? 0;
                });
              },
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'Number of Children:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  numberOfChildren = int.tryParse(value) ?? 0;
                });
              },
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'Preferred Ride Day:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  preferredRideDay = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Willingness to be an Administrator:',
              style: TextStyle(fontSize: 18),
            ),
            Checkbox(
              value: isAdmin,
              onChanged: (value) {
                setState(() {
                  isAdmin = value!;
                });
              },
            ),
            SizedBox(height: 20),
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
