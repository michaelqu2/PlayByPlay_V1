import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import 'package:app_v1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/Setting_Buttons/sports_setting.dart';
import 'question_1.dart';


class RecommendChoicePagePage extends StatefulWidget {
  const RecommendChoicePagePage({super.key});

  @override
  State<RecommendChoicePagePage> createState() => _RecommendChoicePageState();
}

class _RecommendChoicePageState extends State<RecommendChoicePagePage> {
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
    prefs.setString('selected_sport1', _choice??'');
    prefs.setString('selected_level', _level??'');
  }

  Future<void> PageAdvanced() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("SelectionPageChoice", _choice!);
    prefs.setString("SelectionPageLevel", _level!);
  }



  @override
  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 375.0,
              height: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Question1Page(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(350, 230),
                            backgroundColor: Colors.greenAccent, // Background color
                            primary: Colors.white, // Text color
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Short Test",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendChoicePagePage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(350, 230),
                            backgroundColor: Colors.cyan, // Background color
                            primary: Colors.white, // Text color
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Long Test",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

