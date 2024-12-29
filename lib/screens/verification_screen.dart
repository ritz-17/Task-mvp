import 'package:flutter/material.dart';
import '../utils/verification_code_field.dart';
import 'dashboard_screen.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //----------------------- Task-Wan -----------------------------
                Text(
                  "TASK-WAN",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color.fromARGB(255, 122, 90, 248),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //----------------------- Management App -----------------------
                Text(
                  "Management App",
                  style: TextStyle(color: Colors.grey, fontSize: 19),
                ),
                SizedBox(height: 50),

                //---------------------- Verify Account ------------------------
                Text(
                  "Verify account",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 30),

                //----------------------- Image Component ----------------------
                Column(
                  children: [
                    Image.asset("assets/verification.png"),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Please enter the verification number",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "we send to your email",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),

                SizedBox(
                  height: 50,
                ),

                //-------------------- Code Verification -----------------------

                VerificationCodeField(codeLength: 4),
                SizedBox(
                  height: 50,
                ),

                //------------------ Go to Dashboard Button --------------------
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 122, 90, 248),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Go to Dashboard",
                      style: TextStyle(
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
