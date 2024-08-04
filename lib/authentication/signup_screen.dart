import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CommonMethods commonMethods = CommonMethods();
  String _errorMessage = '';
  bool _isOtherSelected = false;

  bool _validatePassword(String password) {
    return password.length >= 6 && RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(password);
  }

  Future<void> _signUp() async {
    final password = _passwordController.text.trim();
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    if (!passwordRegExp.hasMatch(password)) {
      setState(() {
        _errorMessage = S.of(context).passwordRequirementMessage;
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(_firstNameController.text.trim());
        await userCredential.user!.reload();
        User? updatedUser = _auth.currentUser;

        // Save user details in Firestore
        FirebaseFirestore.instance.collection('users').doc(updatedUser!.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'numberOfChildren': _childrenController.text.trim(),
          'departureLocation': _departureController.text.trim(),
        });

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
      } else {
        setState(() {
          _errorMessage = S.of(context).userCreationFailed;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? S.of(context).unknownError;
      });
    } catch (e) {
      setState(() {
        _errorMessage = S.of(context).unknownError;
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
    final Color primaryColor = const Color(0xFF1C4B93);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Text(
                S.of(context).signupTitle,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).createNewAccount,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),
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
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: _childrenController.text.isEmpty ? null : _childrenController.text,
                items: [
                  const DropdownMenuItem(value: '1', child: Text('1')),
                  const DropdownMenuItem(value: '2', child: Text('2')),
                  const DropdownMenuItem(value: '3', child: Text('3')),
                  const DropdownMenuItem(value: '4', child: Text('4')),
                  const DropdownMenuItem(value: '5', child: Text('5')),
                  DropdownMenuItem(value: 'other', child: Text(S.of(context).other)),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value == 'other') {
                      _isOtherSelected = true;
                      _childrenController.clear();
                    } else {
                      _isOtherSelected = false;
                      _childrenController.text = value as String;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: S.of(context).numberOfChildrenLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (_isOtherSelected)
                TextField(
                  controller: _childrenController,
                  decoration: InputDecoration(
                    labelText: S.of(context).enterNumberOfChildren,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                  Text(S.of(context).alreadyHaveAnAccount),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(S.of(context).loginButton, style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
              const Divider(),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
