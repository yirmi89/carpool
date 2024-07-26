import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/pages/home_screen.dart'; // Adjust the import based on your project structure

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

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
            MaterialPageRoute(builder: (context) => HomeScreen(user: updatedUser)),
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
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: _childrenController,
                decoration: const InputDecoration(labelText: 'Number of Children'),
              ),
              TextField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
              ),
              TextField(
                controller: _residenceController,
                decoration: const InputDecoration(labelText: 'Residence'),
              ),
              TextField(
                controller: _vehicleController,
                decoration: const InputDecoration(labelText: 'Vehicle Information'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Sign Up'),
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
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
