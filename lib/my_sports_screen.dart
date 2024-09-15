import 'dart:convert';
import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/route.dart';
import 'package:app_v1/logging_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'logging_display.dart';
import 'logging_record_backup.dart';
import 'logging_record.dart';
import 'sport_logs.dart';

class MySportsScreenPage extends StatefulWidget {
  const MySportsScreenPage({super.key});

  @override
  State<MySportsScreenPage> createState() => _MySportsScreenPageState();
}

class _MySportsScreenPageState extends State<MySportsScreenPage> {
  List<String> sports = [];
  late String selectedSports = sports.isNotEmpty ? sports.first : '';

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('sports')) sports = prefs.getStringList('sports')!;
      sports.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      selectedSports = prefs.getString('selected_sport') ??
          (sports.isNotEmpty ? sports.first : '');
    });
  }

  Future<void> saveUserSports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_sport', selectedSports);
  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
                child: SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(children: [
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 0, bottom: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                        width: screenWidth * 0.43,
                                        height: screenHeight * 0.177,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("LOG NUMBER"),
                                            ])),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.05,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                        width: screenWidth * 0.37,
                                        height: screenHeight * 0.18,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: screenWidth * 0.37,
                                                height: screenHeight * 0.08,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  print("add log");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoggingRecordPage()));
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size(
                                                    screenWidth * 0.37,
                                                    screenHeight * 0.08,
                                                  ),
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          255, 194, 102, 1),
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ])),
                                  )
                                ],
                              )),
                          SizedBox(
                            height: screenHeight * 0.035,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 24, bottom: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "data",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: sports.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    color: Colors.white70,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 10),
                                    // Adjust margin around the Card
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 20),
                                      // Adjusts padding inside the ListTile
                                      // leading: Text('data'),
                                      title: Text(
                                        '${sports[index]}',
                                        style: TextStyle(
                                          fontSize:
                                              18, // Change font size for the text
                                        ),
                                      ),
                                      // subtitle: Text('data'),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_circle_right_outlined,
                                          size: 30, // Change icon size
                                        ),
                                        onPressed: () {
                                          selectedSports = sports[index];
                                          saveUserSports();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SportLogsPage(
                                                      selectedSport:
                                                          sports[index]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ]))))));
  }
}
