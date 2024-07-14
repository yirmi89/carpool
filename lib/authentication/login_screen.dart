import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carpool/authentication/signup_screen.dart';
import 'package:carpool/global/global_var.dart';
import '../methods/common_methods.dart';
import '../pages/home_screen.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final CommonMethods cMethods = CommonMethods();

  void checkIfNetworkIsAvailable() async {
    bool isConnected = await cMethods.checkConnectivity(context);
    if (isConnected) {
      if (signInFormValidation()) {
        signInUser();
      }
    }
  }

  bool signInFormValidation() {
    if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please write a valid email.", context);
      return false;
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar("Your password must be at least 6 characters.", context);
      return false;
    }
    return true;
  }

  void signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const LoadingDialog(messageText: "Allowing you to login..."),
    );

    try {
      final User? userFirebase = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      )).user;

      if (userFirebase != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
        usersRef.once().then((snap) {
          if (snap.snapshot.value != null) {
            if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
              userName = (snap.snapshot.value as Map)["first_name"];
              Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
            } else {
              FirebaseAuth.instance.signOut();
              cMethods.displaySnackBar("You are blocked. Contact admin.", context);
            }
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Your record does not exist as a user.", context);
          }
        });
      }
    } catch (error) {
      cMethods.displaySnackBar(error.toString(), context);
    } finally {
      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color carColor = Color(0xFF333F48); // Dark Gray

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/images/carpool_logo.png', // Update with your image path
                  width: 345,
                  height: 243,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263A6D),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                context,
                controller: emailTextEditingController,
                icon: Icons.alternate_email,
                hintText: 'Email',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: passwordTextEditingController,
                icon: Icons.lock,
                hintText: 'Password',
                obscureText: true,
                iconColor: carColor,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: checkIfNetworkIsAvailable,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: carColor,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF252525),
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

  Widget _buildTextField(BuildContext context, {required TextEditingController controller, required IconData icon, required String hintText, bool obscureText = false, required Color iconColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(icon, color: iconColor, size: 32),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color(0x99BEBEBE),
            ),
            contentPadding: const EdgeInsets.only(left: 50),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFBEBEBE), width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4A73DA), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
