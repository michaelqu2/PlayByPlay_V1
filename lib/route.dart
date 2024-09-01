import 'package:flutter/material.dart';
import '/route.dart';
import '/profile.dart';
import '/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/logging_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/my_sports_screen.dart';
import 'statistics.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int pageIndex = 0;
  List<Widget> pages = [
    const MyHomePage(),
    const StatisticsPage(),
    const MySportsScreenPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[pageIndex], // Main content
          Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30, top: 0),
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Align(
                          alignment: Alignment.center,
                          child: BottomNavigationBar(
                            backgroundColor: Colors.black,
                            type: BottomNavigationBarType.fixed, // Ensures items are evenly spaced
                            selectedFontSize: 0, // Adjust font size for selected items
                            unselectedFontSize: 0,
                            showSelectedLabels: false, // Hide labels
                            showUnselectedLabels: false,
                            items: <BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    // color: pageIndex == 0 ? Colors.white : Colors.transparent, // Highlight the selected icon with a white background
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.home_outlined,
                                    size: 24,
                                    // color: pageIndex == 0 ? Colors.black : Colors.white, // Adjust icon color
                                  ),
                                ),
                                label: "",
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    // color: pageIndex == 1 ? Colors.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.line_axis_outlined,
                                    size: 24,
                                    // color: pageIndex == 1 ? Colors.black : Colors.white,
                                  ),
                                ),
                                label: "",
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    // color: pageIndex == 2 ? Colors.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                    // color: pageIndex == 2 ? Colors.black : Colors.white,
                                  ),
                                ),
                                label: "",
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    // color: pageIndex == 3 ? Colors.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 24,
                                    // color: pageIndex == 3 ? Colors.black : Colors.white,
                                  ),
                                ),
                                label: "",
                              ),
                            ],
                            currentIndex: pageIndex,
                            selectedItemColor: Colors.red,
                            unselectedItemColor: Colors.white,
                            onTap: (int index) {
                              setState(() {
                                pageIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                    )),
              )),
        ],
      ),
    );
  }
}
