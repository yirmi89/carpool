import 'package:flutter/material.dart';

class MyRideDetailsScreen extends StatelessWidget {
  const MyRideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ride Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'My Ride Details Screens',
                style: TextStyle(fontSize: 24),
              ),
              // Add your form fields or other widgets here
            ],
          ),
        ),
      ),
    );
  }
}
