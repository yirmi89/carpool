import 'package:flutter/material.dart';
import 'package:carpool/pages/home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    const Text(
                      "Create a User\'s Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        //color: Color(0xFF6EE2F5), // Set color
                         color: Colors.white
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          children: [
                            TextField(
                              controller: userNameTextEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: "User Name",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  //color: Color(0xFF6EE2F5), // Set color
                                    color: Colors.white
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextField(
                              controller: userPhoneTextEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: "User Phone",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  //color: Color(0xFF6EE2F5), // Set color
                                    color: Colors.white
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextField(
                              controller: emailTextEditingController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "User Email",
                                labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                //fontFamily: 'Comme', // Set font family
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextField(
                              controller: passwordTextEditingController,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: "User Password",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                           //       fontFamily: 'Comme', // Set font family
                               // color: Color(0xFF6EE2F5), // Set color
                                  color: Colors.white
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                             //   fontFamily: 'Comme', // Set font family
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF7E82),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.2,
                                      vertical: screenHeight * 0.02)),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Already have an Account? Login Here",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                       //   fontFamily: 'Comme', // Set font family
                     //     color: Color(0xFF6EE2F5), // Set color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
