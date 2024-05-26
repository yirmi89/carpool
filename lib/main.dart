import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:carpool/pages/splash_screen.dart';
=======
import 'package:carpool/authentication/login_screen.dart';
import 'package:carpool/authentication/signup_screen.dart';
>>>>>>> origin/main

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

<<<<<<< HEAD
=======
  // This widget is the root of your application.
>>>>>>> origin/main
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
<<<<<<< HEAD
      home: const SplashScreen(),
=======
      home: LoginScreen(),
>>>>>>> origin/main
    );
  }
}
