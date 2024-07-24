import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carpool/authentication/login_screen.dart';
import 'package:carpool/pages/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Optional delay for splash screen effect
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(user.uid);
        DataSnapshot snapshot = await usersRef.get();
        if (snapshot.exists) {
          Map<String, dynamic> userMap = Map<String, dynamic>.from(snapshot.value as Map);
          String userName = userMap["first_name"] ?? "User"; // Provide a default value if null
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(userName: userName)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/carpool_logo.png'), // Your splash screen logo
      ),
    );
  }
}
