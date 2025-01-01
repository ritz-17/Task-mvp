import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/utils/bottom_navigation_bar.dart';

import '../provider/auth_provider.dart';
import '../utils/login_text_field.dart';
import '../utils/password_text_field.dart';
import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ------------------ Task-Wan ---------------------------------
                Text(
                  "TASK-WAN",
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ------------------ Management App ---------------------------
                Text(
                  "Management App",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // ----------------- Login to Your Account ---------------------
                Text(
                  "Login to your Account",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // -------------------- Login Field ----------------------------
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
                SizedBox(height: screenHeight * 0.015),

                // ------------------ Password Field ---------------------------
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
                SizedBox(height: screenHeight * 0.01),

                // ---------------- Forgot Password ----------------------------
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.04),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/forgotPassword");
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // ------------------ Login Button -----------------------------
                Center(
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor)
                      : ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              showSnackBar(
                                  context, 'Please enter email and password');
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .login(emailController.text, "password",
                                        passwordController.text);
                                showSnackBar(context, 'Login Successful');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NavBar()),
                                );
                              } catch (e) {
                                showSnackBar(
                                    context, 'Login failed: ${e.toString()}');
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.2,
                              vertical: screenHeight * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // ------------------ Or Login With ----------------------------
                Text(
                  "-- Or Login With --",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // ---------------------- Logo ---------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/google_logo.png',
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                    ),
                    SizedBox(width: screenWidth * 0.15),
                    Image.asset(
                      'assets/facebook_logo.png',
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                    ),
                    SizedBox(width: screenWidth * 0.15),
                    Image.asset(
                      'assets/twitter_logo.png',
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                // ---------------- Don't Have An Account ----------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
