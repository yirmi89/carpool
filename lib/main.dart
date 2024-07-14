import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carpool/authentication/login_screen.dart';
import 'package:carpool/authentication/signup_screen.dart';
import 'package:carpool/pages/splash_screen.dart';
import 'package:carpool/pages/home_screen.dart';
import 'package:carpool/pages/profile_screen.dart';
import 'package:carpool/pages/schedule_screen.dart';
import 'package:carpool/pages/create_group_screen.dart';
import 'package:carpool/pages/join_group_screen.dart';
import 'package:carpool/pages/notifications_screen.dart';
import 'package:carpool/pages/map_search_screen.dart';
import 'package:carpool/pages/search_by_place_screen.dart';
import 'package:carpool/pages/search_by_name_or_id_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity, // or AndroidProvider.safetyNet
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpool Management',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/createGroup': (context) => const CreateGroupScreen(),
        '/joinGroup': (context) => const JoinGroupScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/mapSearch': (context) => const MapSearchScreen(),
        '/searchByPlace': (context) => const SearchByPlaceScreen(),
        '/searchByNameOrID': (context) => const SearchByNameOrIdScreen(),
      },
    );
  }
}
