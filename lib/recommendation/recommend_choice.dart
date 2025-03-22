import 'package:app_v1/recommendation/questionBasedEvaluation/question_short.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detailedBasedEvaluation/question_long_choice.dart';

class RecommendChoicePagePage extends StatefulWidget {
  const RecommendChoicePagePage({super.key});

  @override
  State<RecommendChoicePagePage> createState() => _RecommendChoicePageState();
}

class _RecommendChoicePageState extends State<RecommendChoicePagePage> {
  List<String>? sportsTC = [];
  String? _choice;
  String? _level;
  Color color = Colors.white;
  Color color1 = Color(0xFF0B132B);
  Color color2 = Color(0xFF1C2541);
  Color color3 = Color(0xFF3C75C6);
  Color color4 = Color(0xFF9ED6FF);
  Color color5 = Color(0xFF56F4DC);
  Color color6 = Color(0xFF72f6fb);
  Color color7 = Color(0xFF060A18);
  Color color8 = Color(0xFF3a506b);
  Color color9 = Color(0xFFC91818);
  Color color10 = Color(0xFFFF4D4F);
  Color color11 = Color(0xFFFF7275);
  Color color12 = Color(0xFFFFC4AB);
  Color color13 = Color(0xFFFF8C8C);
  Color color14 = Color(0xFFa31414);
  Color color15 = Color(0xFF9BE4E3);

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

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/sports_background23.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
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
                                  builder: (context) => QuestionShortPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(350, 230),
                              backgroundColor: color4, // Background color
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Questions Based Evaluation",
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
                                  builder: (context) =>
                                      QuestionLongChoicePage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(350, 230),
                              backgroundColor: color6, // Background color
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Detailed Based Evaluation",
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
      ),
    );
  }
}
