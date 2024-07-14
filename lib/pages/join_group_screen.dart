import 'package:flutter/material.dart';

class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define common colors
    const Color primaryColor = Color(0xFF263A6D); // Dark Blue
    const Color secondaryColor = Color(0xFF333F48); // Dark Gray
    const Color backgroundColor = Color(0xFFF2F4F7); // Light Gray

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Group'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Join a Carpool Group',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildJoinOptionCard(
              context,
              'Search by Map Radius',
              Icons.map,
              '/mapSearch',
              primaryColor,
              secondaryColor,
              backgroundColor,
            ),
            const SizedBox(height: 20),
            _buildJoinOptionCard(
              context,
              'Search by Place',
              Icons.school,
              '/searchByPlace', // Placeholder route, you need to implement this screen
              primaryColor,
              secondaryColor,
              backgroundColor,
            ),
            const SizedBox(height: 20),
            _buildJoinOptionCard(
              context,
              'Search by Group Name or ID',
              Icons.group,
              '/searchByNameOrID', // Placeholder route, you need to implement this screen
              primaryColor,
              secondaryColor,
              backgroundColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinOptionCard(BuildContext context, String title, IconData icon, String route, Color primaryColor, Color secondaryColor, Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        color: backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
