import 'package:flutter/material.dart';
import '/profile.dart';
import '/home.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'question_short.dart';
import 'question_long_choice.dart';
import 'question_long_choice.dart';

class QuestionLongDisplayPage extends StatefulWidget {
  const QuestionLongDisplayPage(
      {super.key});




  @override
  State<QuestionLongDisplayPage> createState() =>
      _QuestionLongDisplayPageState();
}

class _QuestionLongDisplayPageState extends State<QuestionLongDisplayPage> {
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
        The goal of using the collected information is to determine the sport that best fits the users. First, completely scan through and analyze the collected data for sportTest, and understand the user’s relative strengths and relative weaknesses physically in profound detail. Determine the sports in which the users show great weaknesses and quickly eliminate them from the potential sports that would fit them. Now determine sports that users show great strength in and keep them highlighted for further analysis. Now, completely scan through and analyze the collected data for psychologicalTest. The psychologicalTest was mainly derived from Connor-Davidson and Athletic Coping Skills Inventory (ACSI-28), adapt the analysis based on this information. raft in detail about the user’s mental state. Understand the user’s relative strengths and relative weaknesses when comes to the psychological part of sports. Improving on the previous physical analysis eliminates sports that users show great psychological disadvantages in while improving on the list of sports where users show strength both physically and psychologically. Now, completely scan through and analyze the collected data for questionTest . Determine the limitation of sports access if any based on the user’s living situation and condition. Eliminate sports from potential fit that was limited due to user’s limited access or anything. Finally, based on the data from questionTest, understand the user’s preference but do not do anything about it. It will be saved for later for pinpointing""";

    List<String> instructionPrompts = [
      "Please print 15 sports1 based on the previous analysis. Ensure the JSON is valid and looks like this: {sports1: <list of sports1>}. Only return the JSON format without any additional text.",
      "Now narrow down the 15 sports to 5 sports using the preference of user. Please print 5 sports_recommend that best fit user’s preference. Ensure the JSON is valid and looks like this: {sports_recommend: <list of sports_recommend>}. Only return the JSON format without any additional text. This is the collected information for sportsTest: ${prefs.getStringList("Long Test")} and ${prefs.getStringList('Long Test Input')}. This is the collected information for psychologicalTest: ${prefs.getStringList("Long Psy")} and ${prefs.getStringList('Long Psy Input')}.This is the collected information for questionsTest: ${prefs.getStringList("Long Other")} and ${prefs.getStringList('Long Other Input')}. "

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
