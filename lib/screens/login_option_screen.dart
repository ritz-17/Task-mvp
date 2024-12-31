import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/auth_provider.dart';
import 'package:task_mvp/screens/login_screen.dart';

class LoginOption extends StatelessWidget {
  const LoginOption({super.key});

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Button widget for reuse
    Widget buildRoleButton(String role, String label) {
      return ElevatedButton(
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).setRole(role);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
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
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.045, // Font size based on screen width
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Select your role',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    // Font size based on screen width
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Login as Manager
                buildRoleButton("manager", "Login as Manager"),

                SizedBox(height: screenHeight * 0.03),

                // Login as Employee
                buildRoleButton("employee", "Login as Employee"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
