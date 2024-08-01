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
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.blue,
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                fill: 1,
              ),
              label: "logging",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "profile",
              backgroundColor: Colors.blue,
            ),
          ],
          currentIndex: pageIndex,
          selectedItemColor: const Color.fromRGBO(255, 0, 0, 1),
          onTap: (int index) {
            setState(() {
              pageIndex = index;
            });
          }),
    );
  }
}
