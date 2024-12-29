import 'package:flutter/material.dart';
import 'package:task_mvp/utils/bottom_navigation_bar.dart';

import '../utils/login_text_field.dart';
import '../utils/password_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //------------------- Task-Wan ---------------------------------
                Text(
                  "TASK-WAN",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color.fromARGB(255, 122, 90, 248),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //------------------- Management App ---------------------------
                Text(
                  "Management App",
                  style: TextStyle(color: Colors.grey, fontSize: 19),
                ),
                SizedBox(height: 40),

                //---------------Login to your Account -------------------------
                Text(
                  "Login to your account",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),

                //-------------------- Login Field -----------------------------
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: LoginTextField(
                    controller: emailController,
                    hintText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add more email validation logic here
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),

                //--------------------- PassWord Field -------------------------
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more password validation logic here
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 5),

                //--------------------- Forgot Password? -----------------------
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 35.0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 122, 90, 248),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //-------------------- Login Button ----------------------------
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // String email = emailController.text;
                        // String password = passwordController.text;

                        // Perform login logic here (e.g., API call)
                        // ...

                        // Navigate to the next screen on successful login
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavBar(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 122, 90, 248),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // ---------------- Or Login With ------------------------------
                Text(
                  "-- Or Login With --",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),

                // ------------------------ Logo -------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Use Image.asset for displaying images
                    Image.asset(
                      'assets/google_logo.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 60),
                    Image.asset(
                      'assets/facebook_logo.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 60),
                    Image.asset(
                      'assets/twitter_logo.png',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // ------------- Don't Have An Account -------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(color: Colors.blue),
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
