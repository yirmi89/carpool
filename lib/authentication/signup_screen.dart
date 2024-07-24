import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carpool/authentication/login_screen.dart';
import 'package:carpool/methods/common_methods.dart';
import 'package:carpool/pages/home_screen.dart';
import 'package:carpool/widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numChildrenController = TextEditingController();
  TextEditingController daysAvailableController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  TextEditingController vehicleInfoController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  void checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  void signUpFormValidation() {
    if (firstNameController.text.trim().length < 3) {
      cMethods.displaySnackBar("Your first name must be at least 3 characters.", context);
    } else if (lastNameController.text.trim().length < 3) {
      cMethods.displaySnackBar("Your last name must be at least 3 characters.", context);
    } else if (!emailController.text.contains("@")) {
      cMethods.displaySnackBar("Please write a valid email.", context);
    } else if (passwordController.text.trim().length < 6) {
      cMethods.displaySnackBar("Your password must be at least 6 characters.", context);
    } else {
      registerNewUser();
    }
  }

  void registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const LoadingDialog(messageText: "Registering your account..."),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ).catchError((errorMsg) {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
      Map<String, String> userDataMap = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "num_children": numChildrenController.text.trim(),
        "days_available": daysAvailableController.text.trim(),
        "destination": destinationController.text.trim(),
        "residence": residenceController.text.trim(),
        "vehicle_info": vehicleInfoController.text.trim(),
        "blockStatus": "no",
      };
      usersRef.set(userDataMap).then((_) {
        String userName = "${firstNameController.text.trim()} ${lastNameController.text.trim()}";
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => HomeScreen(userName: userName)));
      });
    } else {
      cMethods.displaySnackBar("Registration failed. Please try again.", context);
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
                'Sign up',
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
                controller: firstNameController,
                icon: Icons.person,
                hintText: 'First Name',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: lastNameController,
                icon: Icons.person,
                hintText: 'Last Name',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: emailController,
                icon: Icons.alternate_email,
                hintText: 'Email',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: passwordController,
                icon: Icons.lock,
                hintText: 'Password',
                obscureText: true,
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: numChildrenController,
                icon: Icons.child_care,
                hintText: 'Number of Children',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: daysAvailableController,
                icon: Icons.calendar_today,
                hintText: 'Days Available',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: destinationController,
                icon: Icons.school,
                hintText: 'Destination',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: residenceController,
                icon: Icons.home,
                hintText: 'Residence',
                iconColor: carColor,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: vehicleInfoController,
                icon: Icons.directions_car,
                hintText: 'Vehicle Information',
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
                    'Sign Up',
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
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                  child: const Text(
                    'Already have an account? Login',
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
