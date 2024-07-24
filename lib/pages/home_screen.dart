import 'package:flutter/material.dart';
import 'package:carpool/authentication/login_screen.dart';
import 'package:carpool/pages/profile_screen.dart';
import 'package:carpool/pages/notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    const Color carColor = Color(0xFF333F48); // Dark Gray
    const Color textColor = Color(0xFF263A6D); // Text Color
    const Color boxColor = Color(0xFFF2F4F7); // Background color for the feature boxes
    const Color drawerItemColor = Color(0xFFF2F2F2); // Background color for drawer items

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: drawerItemColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: carColor,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.person,
                text: 'Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.notifications,
                text: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Hello $userName!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Welcome to Carpool Management!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureCard(
                  context,
                  'Create Group',
                  Icons.group,
                  '/createGroup',
                  carColor,
                  boxColor,
                ),
                _buildFeatureCard(
                  context,
                  'Join Group',
                  Icons.group_add,
                  '/joinGroup',
                  carColor,
                  boxColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: _buildFeatureCard(
                context,
                'Schedule',
                Icons.schedule,
                '/schedule',
                carColor,
                boxColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, String? route, Color iconColor, Color boxColor) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Card(
        color: boxColor, // Set the background color of the card
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 150,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: iconColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
