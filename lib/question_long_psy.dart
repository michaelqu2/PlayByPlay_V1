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

class QuestionLongPsyPage extends StatefulWidget {
  const QuestionLongPsyPage({super.key});

  @override
  State<QuestionLongPsyPage> createState() => _QuestionLongPsyPageState();
}

class _QuestionLongPsyPageState extends State<QuestionLongPsyPage> {
  late final OpenAI _openAI;
  String? GPTresponse;

  // Split questions into 3 lists
  List<String> questions = [
    // List 1
    "I am able to adapt when changes occur.",
    "I can deal with whatever comes my way.",
    "I try to see the humorous side of things when I am faced with problems.",
    "Having to cope with stress can make me stronger.",
    "I tend to bounce back after illness, injury or other hardships.",
    "I believe I can achieve my goals, even if there are obstacles.",

    // List 2
    "I remain positive and enthusiastic during competition, no matter how badly things are going.",
    "I stay calm and relaxed during competition.",
    "I can quickly bounce back from mistakes during competition.",
    "I keep my emotions under control, even when things are not going well.",
    "I perform well under pressure.",
    "I thrive on challenging situations during competition.",
    "I am at my best when the pressure is on.",
    "I set specific goals for myself to achieve during competition.",
    "I have a specific plan for how I want to achieve my goals in competition.",
    "I maintain focus on my goals during competition.",
    "I mentally prepare myself for each competition.",
    "I block out distractions and focus on what I am doing during competition.",
    "I am good at keeping my concentration on the competition.",
    "I do not worry about performing poorly.",
    "I do not get anxious before a competition.",
    "I am not concerned about others watching me during competition.",
    "I do not worry about making mistakes during competition.",
    "I feel confident in my ability to perform well during competition.",
    "I believe in my ability to reach my goals.",
    "I am willing to put in the time and effort to improve my skills.",
    "I accept constructive criticism from coaches.",
    "I am open to new techniques or strategies suggested by my coaches.",

    // List 3
    // "I play sport for the pleasure I feel in living exciting experiences",
    // "I play sport because I used to have good reasons for doing it, but now I am asking myself if I should continue doing it",
    // "I play sport for the pleasure of discovering new training techniques",
    // "I have the impression of being incapable of succeeding in this sport",
    // "I play sport because it allows me to be well regarded by people that I know",
    // "I play sport to meet people",
    // "I play sport because I feel a lot of personal satisfaction while mastering certain difficult training techniques",
    // "I play sport because it is absolutely necessary to do sports if one wants to be in shape",
    // "I play sport for the prestige of being an athlete",
    // "I play sport for the pleasure I feel while improving some of my weak points",
    // "I play sport for the excitement I feel when I am really involved in the activity",
    // "I must do sports to feel good myself",
    // "I play sport because people around me think it is important to be in shape",
    // "I play sport because it is a good way to learn lots of things which could be useful to me in other areas of my life",
    // "I play sport for the intense emotions I feel doing a sport that I like",
    // "I play sport for the pleasure that I feel while executing certain difficult movements",
    // "I play sport because I would feel bad if I was not taking time to do it",
    // "I play sport to show others how good I am at my sport",
    // "I play sport because to maintain good relationships with my friends",
    // "I play sport because I like the feeling of being totally immersed in the activity",
  ];

  List<String> options = [
    "Not true at all.",
    "Rarely true.",
    "Sometimes true.",
    "Often true.",
    "True nearly all the time."
  ];

  late List<String?> selectedAnswers;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(
        questions.length, null); // Initialize with the number of questions
    _hasProfile().then((value) {
      if (value) {
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
    await prefs.setStringList('Long Psy', questions);

    // Save the test inputs

    await prefs.setStringList(
        'Long Psy Input',
        selectedAnswers
            .where((answer) => answer != null)
            .map((answer) => answer!)
            .toList());

    bool isLongPsy = true;
    await prefs.setBool('Long Psy Check', isLongPsy);

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
    // Convert List<String?> to List<String> by filtering out null values
    return selectedAnswers
        .where((answer) => answer != null)
        .map((answer) => answer!)
        .toList();
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
                Navigator.of(context).pop(); // Close the dialog
                setState(() {}); // Trigger a rebuild
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

  Widget buildQuestionList(int start, int end) {
    // Ensure that the indices are within bounds
    if (start < 0) start = 0;
    if (end > selectedAnswers.length) end = selectedAnswers.length;
    if (start >= end) return const SizedBox.shrink(); // Handle invalid range

    return ListView.builder(
      itemCount: end - start,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        int actualIndex = start + index;
        if (actualIndex >= selectedAnswers.length) {
          return const SizedBox.shrink(); // Or some fallback UI
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              // Adds space around question text
              child: Text(
                questions[actualIndex], // Placeholder for actual question
                style: const TextStyle(
                  fontSize: 13, // Smaller font size for question text
                  fontWeight:
                      FontWeight.bold, // Bold font weight for question text
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              // Adds space around DropdownButton
              child: DropdownButton<String>(
                value: selectedAnswers[actualIndex],
                hint: const Text("Select an answer"),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAnswers[actualIndex] = newValue;
                  });
                },
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("SelectedAnswers length: ${selectedAnswers.length}");

    // Calculate the bounds for each section
    int section1End = 6; // List 1
    int section2End = section1End + 22; // List 2
    int section3End = section2End + 0; // List 3

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: !isLoading
            ? ListView(
                children: [
                  if (questions.length > 0)
                    ExpansionTile(
                      title: const Text("Section 1: List 1 Questions"),
                      children: [buildQuestionList(0, section1End)],
                    ),
                  if (questions.length > section1End)
                    ExpansionTile(
                      title: const Text("Section 2: List 2 Questions"),
                      children: [buildQuestionList(section1End, section2End)],
                    ),
                  if (questions.length > section2End)
                    ExpansionTile(
                      title: const Text("Section 3: List 3 Questions"),
                      children: [buildQuestionList(section2End, section3End)],
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
                  child: const CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
