import 'package:flutter/material.dart';
import 'package:carpool_app/authentication/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carpool App Home'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 5), // Adding space between the icon and text
                Text('Logout'),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to Carpool App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create_group');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Create Group',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/join_group');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Join Group',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ride_details');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Edit your ride details',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
