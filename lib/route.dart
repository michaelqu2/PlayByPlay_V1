import 'package:flutter/material.dart';
import '/route.dart';
import '/profile.dart';
import '/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/logging_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/my_sports_screen.dart';



class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {


  int pageIndex = 0;
  List<Widget> pages = [
    const MyHomePage(),
    const MySportsScreenPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.white,
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "logging",
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "profile",
              backgroundColor: Colors.white,
            ),
          ],
          currentIndex: pageIndex,
          selectedItemColor: const Color.fromRGBO(0, 230, 220, 1),
          onTap: (int index) {
            setState(() {
              pageIndex = index;
            });
          }),
    );
  }
}
