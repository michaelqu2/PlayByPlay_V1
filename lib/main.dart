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
    Color color1 = Color(0xFFE8E8E8);
    Color color2 = Color(0xFFF0F0F0);
    Color color3 = Color(0xFFefefef);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: color3,
          brightness: Brightness.light,
          background: color3,      // Background color
          surface: color3,         // Surface color
        ),
        appBarTheme: AppBarTheme(
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color for large display
            fontFamily: 'Roboto', // Use any custom font
          ),
          bodyLarge: TextStyle(
            fontSize: 18.0,
            color: Colors.black, // Default body text color
            fontFamily: 'Roboto', // Use any custom font
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[800], // A slightly different body text color
            fontFamily: 'Roboto', // Use any custom font
          ),
        ),
        primaryTextTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto', // Specify custom font
          ),
        ),
        useMaterial3: true,
      ),
      home: const RoutePage(),
    );
  }
}