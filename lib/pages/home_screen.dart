import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/authentication/login_screen.dart';
import 'package:carpool/pages/create_group_screen.dart';
import 'package:carpool/pages/search_group_screen.dart';
import 'package:carpool/pages/my_schedule_screen.dart';
import 'package:carpool/pages/my_groups_screen.dart';
import 'package:carpool/pages/my_profile_screen.dart';
import 'package:carpool/pages/settings_screen.dart';
import 'package:carpool/generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  final User? user;
  final void Function(Locale) onLocaleChange;

  const HomeScreen({super.key, this.user, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String firstName = user?.displayName ?? 'User';
    final greetingMessage = S.of(context).hi(firstName);

    Future<void> signOut() async {
      await auth.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(onLocaleChange: onLocaleChange)),
        );
      }
    }

    final Color primaryColor = const Color(0xFF1D7874); // Adjusted color from the carpool logo
    final Color accentColor = const Color(0xFF124E57);

    return Scaffold(
      appBar: AppBar(
        title: Text(greetingMessage, style: TextStyle(color: primaryColor)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Text(
                S.of(context).menu,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(S.of(context).profile),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(S.of(context).settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(onLocaleChange: onLocaleChange)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(S.of(context).signOut),
              onTap: signOut,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).createGroupPrompt,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            S.of(context).createGroupSubPrompt,
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      const Icon(Icons.group_add, color: Colors.white, size: 50),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuButton(context, S.of(context).createGroup, Icons.group_add, primaryColor, const CreateGroupScreen()),
                  _buildMenuButton(context, S.of(context).searchGroup, Icons.search, primaryColor, const SearchGroupScreen()),
                  _buildMenuButton(context, S.of(context).mySchedule, Icons.schedule, primaryColor, const MyScheduleScreen()),
                  _buildMenuButton(context, S.of(context).myGroups, Icons.group, primaryColor, const MyGroupsScreen()),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).lookAround,
                style: TextStyle(color: primaryColor, fontSize: 18),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchGroupScreen()),
                  );
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/home_screen_bottom.png'), // Path to your image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
