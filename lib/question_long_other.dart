import 'package:flutter/material.dart';
import '/profile.dart';
import '/home.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/selection.dart';
import 'dart:convert';
import 'initial_questions_golf_display.dart';
import 'recommend_choice.dart';
import 'dart:async';
import 'question_long_choice.dart';
import 'question_short_display.dart';

class QuestionLongOtherPage extends StatefulWidget {
  const QuestionLongOtherPage({super.key});

  @override
  State<QuestionLongOtherPage> createState() => _QuestionLongOtherPageState();
}

class _QuestionLongOtherPageState extends State<QuestionLongOtherPage> {
  late final OpenAI _openAI;
  String? GPTresponse;
  List<String> questions = [
    "Do you have any chronic health conditions that impact your ability to participate in sports?",
    "How easy is it for you to access sports facilities or gyms in your area?",
    "How accessible is sports training or coaching in your location?",
    "How would you rate your living environment in terms of supporting your sports activities, on a scale of 1 to 10?",
    "How does your current living condition affect your ability to train regularly?",
    "How supportive is your living situation for pursuing sports development opportunities?",
    "Do you receive regular physiotherapy or medical support for sports-related issues?",
    "How often do you participate in competitive sports events or matches?",
    "How many opportunities do you have to progress to higher levels of competition?",
    "How would you rate your exposure to global sports competition on a scale of 1 to 10?",
    "How easy is it for you to secure funding or financial support for your training?",
    "How well do you manage to balance sports training with other life priorities?",
    "How consistent is your training routine over time, on a scale of 1 to 10?",
    "How much support do you receive in terms of resources or facilities for training?",
    "Do you prefer participating in individual sports or team sports?",
    "Do you prefer engaging in competitive sports or recreational activities?",
    "How important is physical contact in your preferred sport or activity?",
    "Do you prefer indoor or outdoor sports?",
    "How important is having access to a competitive environment for you?",
    "Do you enjoy sports that require a high level of technical skill or strategy?",
    "Do you prefer sports that emphasize endurance or physical strength?",
    "How important is the social aspect of the sport to you, such as teamwork or communication?",
    "How significant is the popularity of the sport in your decision to pursue it?"
  ];
  List<TextEditingController> answersController = [];
  bool isLoading = false;

  void _initializeControllers() {
    answersController = List.generate(questions.length, (index) => TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    _hasProfile().then((value) {
      if (value) {
        _initializeControllers();
        setState(() {}); // Trigger a rebuild to ensure UI reflects changes
      } else {
        print("Profile not found. Displaying an error or default behavior.");
        // Optionally show an error dialog
        showAlertDialogue(context);
      }
    }).catchError((error) {
      print("Error checking profile: $error");
      // Optionally handle errors
      showAlertDialogue(context);
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the test names
    await prefs.setStringList('Long Other', questions);

    // Save the test inputs

    await prefs.setStringList(
        'Long Other Input',
        answersController.map((controller) => controller.text).toList());

    bool isLongOther = true;
    await prefs.setBool('Long Other Check', isLongOther);

    print("Data saved successfully!");
  }

  void _printTestData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? testList = prefs.getStringList('Long Psy');
    List<String>? testOutputList = prefs.getStringList('Long Psy Input');

    if (testList != null && testOutputList != null) {
      for (int i = 0; i < testList.length; i++) {
        print(testList[i] + testOutputList[i]);
      }
    }
  }
  List<String> getAnswers() {
    return answersController.map((controller) => controller.text).toList();
  }

  Future<void> showAlertDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text("There was an error! Rerun?")],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _initializeControllers();
              },
              child: const Text("Run Again"),
            )
          ],
        );
      },
    );
  }

  Future<bool> _hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('Name');
  }



  @override
  Widget build(BuildContext context) {
    print("Questions length: ${questions.length}");
    print("AnswersController length: ${answersController.length}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: !isLoading
            ? ListView(
                children: [
                  ListView.builder(
                    itemCount: questions.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      if (index >= answersController.length) {
                        return SizedBox.shrink(); // Or some fallback UI
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Question ${index + 1}: ${questions[index]}"),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Type Your Answer Here",
                              ),
                              controller: answersController[index],
                              onChanged: (value) {
                                // Handle text change here if needed
                                print("Answer for question ${index + 1}: $value");
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveData();
                    },
                    child: Text('Save'), // The child parameter should be here
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _printTestData();
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const QuestionLongChoicePage()));
                    },
                    child: Text('Print'), // The child parameter should be here
                  ),
                ],
              )
            : Center(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
