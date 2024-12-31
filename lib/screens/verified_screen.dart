import 'package:flutter/material.dart';
import 'package:task_mvp/utils/bottom_navigation_bar.dart';
import 'dashboard_screen.dart';

class VerifiedPage extends StatefulWidget {
  const VerifiedPage({super.key});

  @override
  State<VerifiedPage> createState() => _VerifiedPageState();
}

class _VerifiedPageState extends State<VerifiedPage> {
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
                    color: Colors.lightBlue,
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
                    Image.asset("assets/verified.png"),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Your Account has been",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "Verified Successfully!",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),

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
                            builder: (context) => NavBar()),
                        (Route<dynamic> route) =>
                            false, 
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
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
