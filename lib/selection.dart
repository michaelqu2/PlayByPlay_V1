import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import 'package:app_v1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // showDialogue(context:context)
  }

  @override
  void initState() {
    super.initState();
    hasSports().then((value) {
      if(value == true){
        loadUserInfo();
      }
      else{
        _showAlertDialogue();
      }
    })
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Selection Page"),

            DropdownButton<String>(
              hint: _choice == null ? Text("Choose Sports") : Text(_choice!),
              items: sportsTC?.map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _choice = val;
                  print(_choice);
                });
              },
            ),
            DropdownButton<String>(
              hint: _level == null ? Text("Choose Levels") : Text(_level!),
              items: ["Beginner", "Intermediate", "Advanced"].map((
                  String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _level = val;
                  print(_level);
                });
              },
            ),

            TextButton(
              onPressed: () {
                PageAdvanced();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InitialQuestionsGolfPage()));
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

