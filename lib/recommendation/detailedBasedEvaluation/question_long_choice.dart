import 'package:flutter/material.dart';
import '../../profile/profile.dart';
import '../../evaluateYourLevel/initial_questions_golf.dart';
import '../../evaluateYourLevel/evaluateYourLevel.dart';
import '../recommend_choice.dart';
import 'question_long.dart';
import 'question_long_test.dart';
import '../recommend_choice.dart';
import 'question_long_other.dart';
import 'question_long_psy.dart';
import 'question_long_display.dart';

class QuestionLongChoicePage extends StatefulWidget {
  const QuestionLongChoicePage({super.key});

  @override
  State<QuestionLongChoicePage> createState() => _QuestionLongChoicePageState();
}

class _QuestionLongChoicePageState extends State<QuestionLongChoicePage> {
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 375.0,
              height: 600.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestionLongTestPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(300, 150),
                            backgroundColor: color2, // Background color
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Physical Test",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestionLongOtherPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(300, 150),
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
                            "Preference and Condition Questions",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestionLongPsyPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(300, 150),
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
                            "Psychological Test",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestionLongDisplayPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(300, 50),
                            backgroundColor: color, // Background color
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Get Result",
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
