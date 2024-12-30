import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import 'login_option_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    AuthProvider ap = AuthProvider();
    return Scaffold(
      extendBodyBehindAppBar: true,

      //------------------------------ App Bar ---------------------------------
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () async {
                                  await Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logout();
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,MaterialPageRoute(
                                    builder: (context) => LoginOption(),
                                  ),);
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.red),
                                ))
                          ],
                        ));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),

      // ------------------------------- body ----------------------------------
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            const SizedBox(height: 125),

            //-------------------------- Profile Picture -----------------------
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/16869355/pexels-photo-16869355/free-photo-of-black-and-white-shot-of-a-man-in-a-suit.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              ),
            ),
            const SizedBox(height: 20),

            //------------------------------ Name ------------------------------
            Text(
              'Aditya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),

            //--------------------------- Designation --------------------------
            Text(
              '${ap.role}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            //-------------------------- Email ---------------------------------

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Email: ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'abccd@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
