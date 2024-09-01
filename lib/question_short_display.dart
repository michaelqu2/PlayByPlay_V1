import 'package:flutter/material.dart';
import '/profile.dart';
import '/home.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'question_short.dart';

class QuestionShortDisplayPage extends StatefulWidget {
  const QuestionShortDisplayPage(
      {super.key, required this.questions, required this.answers});

  final List<String> questions;
  final List<String> answers;

  @override
  State<QuestionShortDisplayPage> createState() =>
      _QuestionShortDisplayPageState();
}

class _QuestionShortDisplayPageState extends State<QuestionShortDisplayPage> {
  late final OpenAI _openAI;
  String? GPTresponse;
  List<String> responses = [];
  bool isLoading = true;
  List<bool> return_response = [];

  @override
  void initState() {
    super.initState();
    _openAI = OpenAI.instance.build(
        token: dotenv.env['OPENAI_API_KEY'],
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 30),
        ));
    _hasProfile().then((value) {
      if (value) {
        _handleInitialMessage();
      } else {
        print("ERROR");
      }
    });
  }

  Future<void> _fetchQuestions(
      String userPrompt, String instructionPrompt) async {
    final request = ChatCompleteText(model: GptTurbo0631Model(), messages: [
      Messages(role: Role.user, content: userPrompt),
      Messages(role: Role.system, content: instructionPrompt)
    ]);

    ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
    if (response == null || response.choices.isEmpty) {
      print("No response from API");
      return;
    }
    String result = response!.choices.first.message!.content.trim();
    print(result);

    // Process result
    try {
      Map<String, dynamic> resultMap = json.decode(result);
      if (resultMap['sports_recommend'] != null) {
        responses = List<String>.from(resultMap['sports_recommend']);
        return_response = List.generate(responses.length, (index) => false);
        setState(() {
          isLoading = false;
        });
        print(responses);
      } else {
        print("sports_recommend key not found in JSON");
      }
    } catch (e) {
      print("Error Parsing JSON: $e");
    }
  }

  Future<void> _handleInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String userPrompt = """
        Using the collected information, the goal is to determine the sport that best fits the users. First, analyze and completely scan through the collected data, and understand the user’s strengths and relative weaknesses, however, create this list by ignoring the last 9 questions and answers in the list. Do not print the weakness and strength in the user. Determine sports that the users show great weakness in and quickly eliminate them. Now analyze and determine sports that users show great strength in.
    """;
    List<String> instructionPrompts = [
      "Please print 15 sports1 that would best fit the result that ignore the last 9 questions and answers from the list. Ensure the JSON is valid and looks like this: {sports1: <list of sports1>}. Only return the JSON format without any additional text.",
      "Please print 15 sports1 that would best fit the result that ignore the last 9 questions and answers from the list. Ensure the JSON is valid and looks like this: {sports1: <list of sports1>}. Only return the JSON format without any additional text.",
      "Now narrow down the 20 sports to 5 sports using the preference section. Please print 5 sports_recommend that would best fit the result in another section. Ensure the JSON is valid and looks like this: {sports_recommend: <list of sports_recommend>}. Only return the JSON format without any additional text. This is the collected information: ${widget.questions} and ${widget.answers}"
    ];

    for (String instructionPrompt in instructionPrompts) {
      await _fetchQuestions(userPrompt, instructionPrompt);
    }
  }

  Future<void> saveImprovements(String sports) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedImprovements =
        prefs.getStringList("sports_recommend") ?? [];
    if (!savedImprovements.contains(sports)) {
      savedImprovements.add(sports);
      prefs.setStringList("sports_recommend", savedImprovements);
      print("Sports Saved");
    } else {
      print("Sports recommend is already saved");
    }
  }

  Future<bool> _hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('Name');
  }

  void handleButtonPress() {
    for (int i = 0; i < return_response.length; i++) {
      if (return_response[i]) {
        saveImprovements(responses[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: !isLoading
            ? ListView(
                children: <Widget>[
                  ListView.builder(
                      itemCount: responses.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                            title: Text(responses[index]),
                            value: return_response[index],
                            onChanged: (value) {
                              setState(() {
                                return_response[index] = value ?? false;
                              });
                            });
                      }),
                  ElevatedButton(
                      onPressed: () {
                        handleButtonPress();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        ).then((value) => Navigator.pop(context));
                      },
                      child: const Text("Return Home"))
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
