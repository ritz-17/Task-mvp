import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utils/login_text_field.dart';
import '../utils/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
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
                  "Enter your Email ID",
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
                  hintText: 'Enter Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.015),

                // ------------------ Send Email Button ------------------------
                Center(
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor)
                      : ElevatedButton(
                        
                          onPressed: () async {
                            if (emailController.text.isEmpty) {
                              showSnackBar(context, 'Please enter email');
                              return;
                            }

                            final emailRegex = RegExp(r'^[^@]+@[^@]+\\.[^@]+');
                            if (!emailRegex.hasMatch(emailController.text)) {
                              showSnackBar(context,
                                  'Please enter a valid email address');
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            try {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              await authProvider
                                  .forgotPassword(emailController.text);
                              showSnackBar(context,
                                  'Forgot Password email sent successfully!');
                            } catch (e) {
                              showSnackBar(context, 'Error: ${e.toString()}');
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
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
                            'Send Email',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
