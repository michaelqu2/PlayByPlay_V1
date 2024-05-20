import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import 'package:app_v1/logging_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoggingRecordPage extends StatefulWidget {
  const LoggingRecordPage({super.key});

  @override
  State<LoggingRecordPage> createState() => _LoggingRecordPageState();
}

class _LoggingRecordPageState extends State<LoggingRecordPage> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _sportController = TextEditingController();
  List<String> sports = [];
  late String selected_sports;

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dateController.text = prefs.getString("logDate") ?? '';
      _timeController.text = prefs.getString("logTime") ?? '';
      _sportController.text = prefs.getString("logSport") ?? '';
      if (prefs.containsKey('sports')) sports = prefs.getStringList('sports')!;
      selected_sports = sports.isNotEmpty ? sports.first : '';
    });
  }

  Future<void> saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonlog = prefs.getString(selected_sports!)??'[]';
    List logs = jsonDecode(jsonlog);
    Map data = {
      'logDate': _dateController.text,
      'logTime': _timeController.text,
      'logSport': _sportController.text,
    };
    logs.add(data);
    prefs.setString(selected_sports!,jsonEncode(logs));
    print("Log is added");
  }
  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: 500.0,
                height: 100.0,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Log #",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ])),
            const Divider(
              height: 5,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Container(
                width: 500.0,
                height: 300.0,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 300.0,
                          height: 300.0,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Date",
                                      hintText: "Date",
                                    ),
                                    controller: _dateController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Time",
                                      hintText: "Time",
                                    ),
                                    controller: _timeController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Sport",
                                      hintText: "Sport",
                                    ),
                                    controller: _sportController,
                                  ),
                                )
                              ])),
                    ])),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                alignment: Alignment.center,
              ),
              onPressed: () {
                print("save");
                saveUserInfo();
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoggingDisplayPage(selected_sports: selected_sports,)));
              },
              child: const Text(
                "Save",
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
