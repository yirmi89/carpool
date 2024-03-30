import 'package:flutter/material.dart';
import 'package:carpool_app/authentication/login_screen.dart';
import 'package:carpool_app/pages/create_group_page.dart';
import 'package:carpool_app/pages/join_group_page.dart';
import 'package:carpool_app/pages/edit_ride_details_page.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateGroupPage()),
                );
              },
              child: const Text('Create Group'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinGroupPage()),
                );
              },
              child: const Text('Join Group'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditRideDetailsPage()),
                );
              },
              child: const Text('Edit Your Ride Details'),
            ),
          ],
        ),
      ),
    );
  }
}