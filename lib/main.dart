import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/auth_provider.dart';
import 'package:task_mvp/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        // Add more providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task App',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 122, 90, 248),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
