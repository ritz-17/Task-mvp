import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/utils/address_field.dart';
import 'package:task_mvp/utils/bottom_navigation_bar.dart';
import 'package:task_mvp/utils/dob_field.dart';
import 'package:task_mvp/utils/utils.dart';

import '../provider/auth_provider.dart';
import '../utils/login_text_field.dart';
import '../utils/password_text_field.dart';
import '../utils/phone_number_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final DOBController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //------------------- Task-Wan Logo ------------------------
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "TASK-WAN",
                              style: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Management App",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      //------------------- Create Your Account ------------------
                      Center(
                        child: Text(
                          "Create your account",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      //------------------- First Name Field ---------------------
                      LoginTextField(
                        controller: fNameController,
                        hintText: 'First Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your First Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      //------------------- Last Name Field ----------------------

                      LoginTextField(
                        controller: lNameController,
                        hintText: "Last Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Last Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      //--------------------- DOB Field ------------------------

                      DOBTextField(
                          controller: DOBController, hintText: "Date of Birth"),
                      SizedBox(height: screenHeight * 0.01),

                      //--------------------- Address Field ------------------------

                      AddressTextField(
                          controller: addressController, hintText: "Address"),
                      SizedBox(height: screenHeight * 0.01),

                      //------------------- Email Field --------------------------

                      LoginTextField(
                        controller: emailController,
                        hintText: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      //------------------- Phone Field --------------------------

                      PhoneNumberField(
                        controller: phoneController,
                        hintText: 'Phone Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01), // Reduced height

                      //------------------- Password Field -----------------------

                      PasswordTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      //------------------- Signup Button ------------------------
                      Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).primaryColor)
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .register(
                                              emailController.text,
                                              phoneController.text,
                                              fNameController.text,
                                              lNameController.text,
                                              "password",
                                              passwordController.text);
                                      showSnackBar(
                                          context, 'Signup Successful');
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NavBar()),
                                      );
                                    } catch (e) {
                                      showSnackBar(context,
                                          'Signup failed: ${e.toString()}');
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.15,
                                    vertical: screenHeight * 0.015,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Signup',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      //------------------- Social Login -------------------------
                      Center(
                        child: Text(
                          "-- Or Register With --",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google_logo.png', width: 30),
                          SizedBox(width: screenWidth * 0.05),
                          Image.asset('assets/facebook_logo.png', width: 30),
                          SizedBox(width: screenWidth * 0.05),
                          Image.asset('assets/twitter_logo.png', width: 30),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.0001),

                      //----------------- Already Have Account -------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: 12),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false, // Removes all previous routes
                              );
                            },
                            child: const Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
