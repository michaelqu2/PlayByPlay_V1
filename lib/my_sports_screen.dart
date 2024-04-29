import 'dart:convert';
import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/route.dart';
import 'package:app_v1/logging_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logging_display.dart';

class MySportsScreenPage extends StatefulWidget {
  const MySportsScreenPage({super.key});

  @override
  State<MySportsScreenPage> createState() => _MySportsScreenPageState();
}

class _MySportsScreenPageState extends State<MySportsScreenPage> {
  List<String> sports = [];

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('sports')) sports = prefs.getStringList('sports')!;
      sports.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                        child: Column(children: [
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
                          ListView(children: [
                            Text('Sport logs'),
                            SizedBox(
                                child: Scrollbar(
                                    child: ListView.separated(
                                      itemCount: sports.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Card(
                                          child: ListTile(
                                            title: Text('${sports[index]}'),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.ice_skating),
                                              onPressed: () {
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
                                          (BuildContext context, int index) =>
                                      const Divider(),
                                    )))
                          ])
                        ]))))));
  }
}
