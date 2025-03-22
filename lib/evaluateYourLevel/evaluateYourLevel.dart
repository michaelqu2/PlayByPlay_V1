import 'package:flutter/material.dart';
import '../profile/profile.dart';
import 'initial_questions_golf.dart';
import 'package:app_v1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/Setting_Buttons/sports_setting.dart';

import '../constants.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  List<String>? sportsTC = [];
  String? _choice;
  String? _level;

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sportsTC = prefs.getStringList('sports');
    });
  }

  Future<void> saveUserSports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_sport1', _choice ?? '');
    prefs.setString('selected_level', _level ?? '');
  }

  Future<void> PageAdvanced() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("SelectionPageChoice", _choice!);
    prefs.setString("SelectionPageLevel", _level!);
  }

  Future<bool> hasSports() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('sports');
  }

  void _showAlertDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please Update Your Settings'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SportsSettingPage()))
                          .then((value) {
                        loadUserInfo();
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      "You need to select a sports",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    // showDialogue(context:context)
  }

  @override
  void initState() {
    super.initState();
    hasSports().then((value) {
      if (value == true) {
        loadUserInfo();
      } else {
        _showAlertDialogue();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluate Your Level"),
        backgroundColor: color,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/sports_background18.jpg",
            ),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Your Sport",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: _choice == null
                            ? Text("Choose Sports")
                            : Text(_choice!),
                        items: sportsTC?.map((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _choice = val;
                            print(_choice);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Your Level",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: _level == null
                            ? Text("Choose Levels")
                            : Text(_level!),
                        items: ["Beginner", "Intermediate", "Advanced"]
                            .map((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _level = val;
                            print(_level);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_choice == null || _level == null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                  'Please Select Your Sport and Level'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      PageAdvanced();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InitialQuestionsGolfPage()));
                      saveUserSports();
                    }
                    // print(_choice);
                    // print(_level);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: color2,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 25)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
