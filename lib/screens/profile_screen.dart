import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      //------------------------------ App Bar ---------------------------------
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
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
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
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
                color: Colors.white,
              ))
        ],
      ),

      // ------------------------------- body ----------------------------------
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 100, 75, 255),
              Color.fromARGB(255, 150, 125, 255),
              Color.fromARGB(255, 200, 175, 255),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
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
            const Text(
              'Mayur Srivastav',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),

            //--------------------------- Designation --------------------------
            const Text(
              'Manager',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
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
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'abccd@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
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
