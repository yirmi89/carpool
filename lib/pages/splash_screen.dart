import 'package:flutter/material.dart';
import 'package:carpool/authentication/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const SplashScreen({super.key, required this.onLocaleChange});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen(onLocaleChange: widget.onLocaleChange)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Image.asset(
            "assets/images/carpool_logo.png",
            height: screenHeight * 0.3, // Adjust the logo size as needed
          ),
        ),
      ),
    );
  }
}
