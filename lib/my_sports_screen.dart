import 'dart:convert';
import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/route.dart';
import 'package:app_v1/logging_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'logging_display.dart';

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
      selectedSports = prefs.getString('selected_sport') ?? (sports.isNotEmpty ? sports.first : '');
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
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(

        ),
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
                decoration: BoxDecoration(

                  color: Colors.white,
                ),
                child: SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(children: [
                          Container(
                              height: 70,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 0, bottom: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 150.0,
                                      height: 20,
                                      color: Colors.white,
                                      child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            height: 50,
                            thickness: 2,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.black,
                          ),
                            Expanded(
                              child: Scrollbar(
                                child: ListView.separated(
                                    itemCount: sports.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text('${sports[index]}'),
                                          trailing: IconButton(
                                            icon: const Icon(
                                                Icons.arrow_circle_right_outlined),
                                            onPressed: () {
                                              selectedSports =sports[index];
                                              saveUserSports();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoggingDisplayPage(
                                                            selected_sports:
                                                            sports[index])),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) => const Divider(),
                                ))
                          )
                        ]))))));
  }
}
