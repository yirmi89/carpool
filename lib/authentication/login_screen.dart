import 'package:flutter/material.dart';
import 'package:carpool_app/authentication/signup_screen.dart';
import 'package:carpool_app/global/global_var.dart';
import 'package:carpool_app/methods/common_methods.dart';
import 'package:carpool_app/pages/home_page.dart';
import 'package:carpool_app/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();



  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation()
  {

    if(!emailTextEditingController.text.contains("@"))
    {
      cMethods.displaySnackBar("please write valid email.", context);
    }
    else if(passwordTextEditingController.text.trim().length < 5)
    {
      cMethods.displaySnackBar("your password must be atleast 6 or more characters.", context);
    }
    else
    {
      signInUser();
    }
  }

  signInUser() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Allowing you to Login..."),
    );


    if(!context.mounted) return;
    Navigator.pop(context);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                "Log In",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 22),

                    ElevatedButton(
                      onPressed: ()  {
                        checkIfNetworkIsAvailable();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      ),
                      child: const Text("Log In"),
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 12),
              // ElevatedButton(
              //   onPressed: () async {
              //     // Check if there is internet connectivity
              //     bool isConnected = await checkIfNetworkIsAvailable();
              //
              //     if (isConnected) {
              //       // If there is internet, navigate to home page
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(builder: (context) => HomePage()),
              //       );
              //     } else {
              //       // Show no internet connection error message
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text('No internet connection'),
              //         ),
              //       );
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.purple,
              //     padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              //   ),
              //   child: const Text("Log In"),
              // ),


            ],
          ),
        ),
      ),
    );
  }
}
