import 'package:flutter/material.dart';
import '../utils/login_text_field.dart';
import '../utils/password_text_field.dart';
import 'dashboard_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

                //---------------Create your Account -------------------------
                Text(
                  "Create your account",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),

                //-------------------- Username -----------------------------
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: LoginTextField(
                    controller: emailController,
                    hintText: 'Username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      // Add more email validation logic here
                      return null;
                    },
                  ),
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

                //------------------ Confirm PassWord Field --------------------
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PasswordTextField(
                    controller: passwordController,
                    hintText: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more password validation logic here
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),

                //-------------------- Register Button ----------------------------
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
                            builder: (context) => DashboardScreen(),
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
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // ---------------- Or Register With ------------------------------
                Text(
                  "-- Or Register With --",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
