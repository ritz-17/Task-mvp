import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/screens/register_screen.dart';
import 'package:task_mvp/utils/bottom_navigation_bar.dart';

import '../provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoScale = 1.0;

  // Logo scaling animation
  void _animateLogo() async {
    const duration = Duration(milliseconds: 1500);
    while (mounted) {
      await Future.delayed(duration ~/ 2, () {
        setState(() {
          _logoScale = _logoScale == 1.0 ? 0.8 : 1.0;
        });
      });
      await Future.delayed(duration ~/ 2);
    }
  }

  // Navigation logic based on auth status
  void _navigateAfterDelay() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Short delay to display splash

    if (mounted) {
      var authProvider = context.read<AuthProvider>();
      bool isSignedIn = await authProvider.checkIfSignedIn();

      if (isSignedIn) {
        await authProvider.getDataFromHive();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isSignedIn ? const NavBar() : const RegisterScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _animateLogo();
    _navigateAfterDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 122, 90, 248),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: _logoScale,
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.easeInOut,
                    child: const Icon(Icons.shopping_cart,
                        color: Colors.white, size: 100),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Task App",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
