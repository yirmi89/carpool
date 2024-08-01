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
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final User? user;
  final void Function(Locale) onLocaleChange;

  const HomeScreen({super.key, this.user, required this.onLocaleChange});

  String getGreetingMessage(BuildContext context, String firstName) {
    final hour = DateTime.now().hour;
    final S localization = S.of(context);

    if (hour > 5 && hour < 12) {
      return localization.goodMorning(firstName);
    }
    else if (hour > 12 && hour < 17) {
      return localization.goodAfternoon(firstName);
    } else if (hour > 17 && hour < 20) {
      return localization.goodEvening(firstName);
    } else {
      return localization.goodNight(firstName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String firstName = user?.displayName ?? 'User';
    final greetingMessage = getGreetingMessage(context, firstName);

    Future<void> signOut() async {
      await auth.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(onLocaleChange: onLocaleChange)),
        );
      }
    }

    final Color primaryColor = const Color(0xFF1C4B93); // Adjusted color from the carpool logo

    return Scaffold(
      appBar: AppBar(
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
                  MaterialPageRoute(builder: (context) => MyProfileScreen(onLocaleChange: onLocaleChange)),
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
            children: [
              Text(
                greetingMessage,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                S.of(context).createGroup,
                Icons.group_add,
                primaryColor,
                CreateGroupScreen(onLocaleChange: onLocaleChange),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                S.of(context).searchGroup,
                Icons.search,
                primaryColor,
                SearchGroupScreen(onLocaleChange: onLocaleChange),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                S.of(context).mySchedule,
                Icons.schedule,
                primaryColor,
                MyScheduleScreen(onLocaleChange: onLocaleChange),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                S.of(context).myGroups,
                Icons.group,
                primaryColor,
                MyGroupsScreen(onLocaleChange: onLocaleChange),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 14),
          ],
        ),
      ),
    );
  }
}
