import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/selection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: 225.0,
                height: 150.0,
                color: Colors.white,
                alignment: Alignment.bottomCenter,
                child: Column(children: [
                  Text(
                    "     ",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ])),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SelectionPage()));
              },
              child: const Text(
                "Initial Golf Questions",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
