import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/main.dart';

class LoggingDisplayPage extends StatefulWidget {
  const LoggingDisplayPage({super.key});

  @override
  State<LoggingDisplayPage> createState() => _LoggingDisplayPageState();
}

class _LoggingDisplayPageState extends State<LoggingDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
              child: SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          Container(
                              width: 500,
                              height: 200,
                              child: Column(children: [
                                Text(" LOG NUMBER"),
                                TextButton(
                                    onPressed: () {
                                      print("add log");
                                    },
                                    child: const Text("Add Log"))
                              ],)
                          )
                        ],
                      ))))),
    );
  }
}
