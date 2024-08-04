import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/pages/home_screen.dart';
import 'package:carpool/generated/l10n.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const LoginScreen({super.key, required this.onLocaleChange});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  bool _validatePassword(String password) {
    return password.length >= 6 && RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(password);
  }

  Future<void> _login() async {
    final password = _passwordController.text.trim();
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    if (!passwordRegExp.hasMatch(password)) {
      setState(() {
        _errorMessage = S.of(context).passwordRequirementMessage;
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: password,
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              onLocaleChange: widget.onLocaleChange,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'wrong-password') {
          _errorMessage = S.of(context).incorrectPasswordMessage;
        } else {
          _errorMessage = e.message ?? 'An unknown error occurred';
        }
      });
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).enterEmailToResetPassword;
      });
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _errorMessage = S.of(context).passwordResetEmailSent;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occurred';
      });
    }
  }

  void _signInWithGoogle() {
    // Add your Google Sign-In logic here
  }

  void _signInWithFacebook() {
    // Add your Facebook Sign-In logic here
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93); // Adjusted color from the carpool logo

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Text(
                S.of(context).loginTitle,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).welcomeBack,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: S.of(context).enterUsernameOrEmail,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: S.of(context).enterYourPassword,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: Text(
                    S.of(context).forgotPassword,
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  S.of(context).loginTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).dontHaveAnAccount),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(onLocaleChange: widget.onLocaleChange),
                        ),
                      );
                    },
                    child: Text(S.of(context).signupButton, style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
              const Divider(),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: primaryColor),
                  ),
                ),
                icon: Image.asset('assets/images/google_icon.png', height: 24, width: 24),
                label: Text(S.of(context).signInWithGoogle),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _signInWithFacebook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Image.asset('assets/images/facebook_icon.png', height: 24, width: 24),
                label: Text(S.of(context).signInWithFacebook),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
