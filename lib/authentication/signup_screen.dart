import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/pages/home_screen.dart'; // Adjust the import based on your project structure
import 'package:carpool/generated/l10n.dart'; // Correct import for S

class SignUpScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const SignUpScreen({super.key, required this.onLocaleChange});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Ensure the user is created
      if (userCredential.user != null) {
        print('User created: ${userCredential.user!.uid}');

        // Update the user's display name
        await userCredential.user!.updateDisplayName(_firstNameController.text.trim());
        await userCredential.user!.reload(); // Refresh the user's profile
        User? updatedUser = _auth.currentUser; // Get the updated user

        // Navigate to HomeScreen
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: updatedUser,
                  onLocaleChange: widget.onLocaleChange,
                )),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'User creation failed. Please try again.';
        });
        print('User creation failed. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occurred';
      });
      print('FirebaseAuthException: $e');
    } catch (e) {
      setState(() {
        _errorMessage = 'An unknown error occurred';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).signup)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: S.of(context).firstName),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: S.of(context).lastName),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: S.of(context).email),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: S.of(context).password),
                obscureText: true,
              ),
              TextField(
                controller: _childrenController,
                decoration: InputDecoration(labelText: S.of(context).numberOfChildren),
              ),
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: S.of(context).destination),
              ),
              TextField(
                controller: _residenceController,
                decoration: InputDecoration(labelText: S.of(context).residence),
              ),
              TextField(
                controller: _vehicleController,
                decoration: InputDecoration(labelText: S.of(context).vehicleInformation),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text(S.of(context).signup),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.of(context).loginPrompt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
