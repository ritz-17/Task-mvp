import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/auth_provider.dart';
import 'package:task_mvp/provider/timer_provider.dart';
import 'package:task_mvp/provider/task_provider.dart';
import 'package:task_mvp/provider/employee_provider.dart';
import 'package:task_mvp/screens/create_long_task_screen.dart';

import 'package:task_mvp/screens/splash_screen.dart';
import 'package:task_mvp/screens/login_screen.dart';
import 'package:task_mvp/screens/signup_screen.dart';
import 'package:task_mvp/screens/profile_screen.dart';
import 'package:task_mvp/screens/dashboard_screen.dart';
import 'package:task_mvp/screens/employee_task_screen.dart';
import 'package:task_mvp/screens/task_detail_screen.dart';
import 'package:task_mvp/screens/verification_screen.dart';
import 'package:task_mvp/screens/verified_screen.dart';
import 'package:task_mvp/screens/forgot_password_screen.dart';

import 'models/task_model.dart';
import 'screens/create_short_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task App',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 122, 90, 248),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/profile': (context) => const ProfileScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/employeeTasks': (context) => const TaskListScreen(),
          '/verification': (context) => const VerificationPage(),
          '/verified': (context) => const VerifiedPage(),
          '/forgotPassword': (context) => const ForgotPasswordPage(),
          '/createLongTask': (context) => const CreateLongTask(),
          '/createShortTask': (context) => const CreateShortTask(),
          '/task-details': (context) {
            final taskId = ModalRoute.of(context)?.settings.arguments as String;
            return TaskDetailScreen(taskId: taskId);
          },
        },
      ),
    );
  }
}
