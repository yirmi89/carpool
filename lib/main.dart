import 'package:flutter/material.dart';
import 'package:carpool_app/authentication/login_screen.dart';
import 'package:carpool_app/authentication/signup_screen.dart';
import 'package:carpool_app/home/home_screen.dart';
import 'package:carpool_app/create_group_screen.dart';
import 'package:carpool_app/join_group_screen.dart';
import 'package:carpool_app/ride_details_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/signup', // Set initial route to signup screen
      routes: {
        '/home': (context) => HomeScreen(), // HomeScreen route
        '/signup': (context) => SignUpScreen(), // SignUpScreen route
        '/login': (context) => LoginScreen(), // LoginScreen route
        '/create_group': (context) => CreateGroupScreen(), // CreateGroupScreen route
        '/join_group': (context) => JoinGroupScreen(), // JoinGroupScreen route
        '/ride_details': (context) => RideDetailsScreen(),
        // Define other routes here
      },
    );
  }
}
