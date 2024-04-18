import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/main.dart';
import 'package:app_v1/logging_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggingDisplayPage extends StatefulWidget {
  const LoggingDisplayPage({super.key});

  @override
  State<LoggingDisplayPage> createState() => _LoggingDisplayPageState();
}

class _LoggingDisplayPageState extends State<LoggingDisplayPage> {
  String _sport = "";
  late SharedPreferences prefs;

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sport = (prefs.getString("logSport") ?? '');

    });
  }
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
                              height: 150,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 150.0,
                                      height: 200.0,
                                      color: Colors.white,
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("LOG NUMBER"),
                                          ])),
                                  Container(
                                      width: 100.0,
                                      height: 50.0,
                                      color: Colors.greenAccent,
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  print("add log");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoggingRecordPage()));
                                                },
                                                child: const Text("Add Log")),
                                          ])),
                                ],
                              )),
                          const Divider(
                            height: 20,
                            thickness: 2,
                            indent: 10,
                            endIndent: 0,
                            color: Colors.black,
                          ),
                          Container(
                              width: 500.0,
                              height: 30.0,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(_sport),

                                  ])),
                        ],
                      ))))),
    );
  }
}
