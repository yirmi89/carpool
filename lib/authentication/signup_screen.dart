import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/pages/home_screen.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carpool/methods/common_methods.dart';

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
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CommonMethods commonMethods = CommonMethods();
  String _errorMessage = '';

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(_firstNameController.text.trim());
        await userCredential.user!.reload();
        User? updatedUser = _auth.currentUser;

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: updatedUser,
                onLocaleChange: widget.onLocaleChange,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'User creation failed. Please try again.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occurred';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unknown error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93); // Adjusted color from the carpool logo

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).login,
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Text(
                S.of(context).signup,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Create a new account',
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: S.of(context).firstName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: S.of(context).lastName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: S.of(context).email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: S.of(context).password,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _childrenController,
                decoration: InputDecoration(
                  labelText: S.of(context).numberOfChildren,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _childrenController.text = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _departureController,
                  decoration: InputDecoration(
                    labelText: S.of(context).departureLocation,
                    hintText: '', // Removed text
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await commonMethods.getAddresses(_departureController.text, pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.toString()),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _departureController.text = suggestion.toString();
                },
              ),
              const SizedBox(height: 16),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: S.of(context).destinationLocation,
                    hintText: S.of(context).chooseAddress,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await commonMethods.getAddresses(_destinationController.text, pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.toString()),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _destinationController.text = suggestion.toString();
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _vehicleController.text.isEmpty ? null : _vehicleController.text,
                items: [
                  DropdownMenuItem(value: '5 seats', child: Text('5 seats')),
                  DropdownMenuItem(value: 'Up to 5 seats', child: Text('Up to 5 seats')),
                  DropdownMenuItem(value: 'More than 5 seats', child: Text('More than 5 seats')),
                ],
                onChanged: (value) {
                  setState(() {
                    _vehicleController.text = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: S.of(context).vehicleInformation,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  S.of(context).signup,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
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
                  Text(S.of(context).signUpPrompt),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(S.of(context).login, style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
