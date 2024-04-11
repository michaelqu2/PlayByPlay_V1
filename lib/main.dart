import 'package:flutter/material.dart';
import '/main.dart';
import '/profile.dart';
import '/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future <void> main() async{
  await dotenv.load(fileName:'assets/.env.example');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        primaryTextTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.blue,
          )
        ),
        useMaterial3: true,
      ),
      home: const RoutePage(),
    );
  }
}

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});



  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {

  int pageIndex = 0;
  List <Widget> pages = [
    const MyHomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages [pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
          items: const < BottomNavigationBarItem> [
            BottomNavigationBarItem(icon: Icon(Icons.home),
              backgroundColor: Colors.white,
              label: "home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person),
              label: "profile",
              backgroundColor: Colors.white,
            ),
          ],
          currentIndex: pageIndex,
          selectedItemColor:const Color.fromRGBO(0, 230, 220, 1),
          onTap: (int index){
            setState(() {
              pageIndex = index;
            });
          }
      ),

    );
  }
}
