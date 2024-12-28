import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/auth_provider.dart';
import 'package:task_mvp/provider/timer_provider.dart'; // Import TimerProvider
import 'package:task_mvp/screens/login_screen.dart';
import 'package:task_mvp/screens/profile_screen.dart';
import 'package:task_mvp/screens/verified_screen.dart';
import 'package:task_mvp/screens/splashScreen.dart';

import 'screens/dashboard_screen.dart';
import 'screens/employee_task_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/verification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
<<<<<<< HEAD
  runApp(
    MultiProvider(
=======
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
>>>>>>> master
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<TimerProvider>(create: (_) => TimerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task App',
        theme: ThemeData(
<<<<<<< HEAD
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 122, 90, 248),
          ),
          useMaterial3: true,
        ),
        home: ProfileScreen(),
=======
          primaryColor: const Color.fromARGB(255, 122, 90, 248),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
>>>>>>> master
      ),
    ),
  );
}
