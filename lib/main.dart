import 'package:flutter/material.dart';
import '/route.dart';
import '/profile.dart';
import '/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/logging_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'assets/.env.example');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        ),
        primaryTextTheme: const TextTheme(
            bodyMedium: TextStyle(
          color: Colors.blue,
        )),
        useMaterial3: true,
      ),
      home: const RoutePage(),
    );
  }
}


