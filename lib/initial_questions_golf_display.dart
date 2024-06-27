import 'package:flutter/material.dart';
import '/profile.dart';
import '/home.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/selection.dart';
import 'dart:convert';

class InitialQuestionsGolfDisplayPage extends StatefulWidget {
  const InitialQuestionsGolfDisplayPage(
      {super.key, required this.questions, required this.answers});

  final List<String> questions;
  final List<String> answers;

  @override
  State<InitialQuestionsGolfDisplayPage> createState() =>
      _InitialQuestionsGolfDisplayPageState();
}

class _InitialQuestionsGolfDisplayPageState
    extends State<InitialQuestionsGolfDisplayPage> {
  late final OpenAI _openAI;
  String? GPTresponse;
  List<String> response = [];
  bool isLoading = true;
  List<bool> return_response = [];

  Future<void> _handleInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String userPrompt =
        'I am a ${prefs.getString('selected_gender')}. I play ${prefs.getString('selected_sport1')}. I am a ${prefs.getString('selected_level')}.';
    String instructionPrompt =
        "Base off the ${widget.questions} and ${widget.answers} received, provide three aspects of my game that I should be improving on. Please make sure that you only return a JSON format that look like this: {Improvements: <list of improvements>}. Ensure the JSON is valid and do not write anything before or after the JSON structure provided.";
    print(instructionPrompt);
    final request = ChatCompleteText(model: GptTurbo0631Model(), messages: [
      Messages(
        role: Role.user,
        content: userPrompt,
      ),
      Messages(
        role: Role.system,
        content: instructionPrompt,
      )
    ]);
    ChatCTResponse? response1 =
        await _openAI.onChatCompletion(request: request);
    String result = response1!.choices.first.message!.content.trim();
    print(result);
    setState(() {
      try {
        Map<String, dynamic> resultMap =
            Map<String, dynamic>.from(json.decode(result.toString()));
        response = List<String>.from(resultMap['improvements']);
        return_response = List.generate(response.length, (index) => false);
        isLoading = false;
        print(response);
      } catch (e) {
        print("Error Parsing JSON $e");
      }
    });
    // print(result);
  }

  void handleButtonPress() {
    for (int i = 0; i < return_response.length; i++) {
      if (return_response[i]) {
        saveImprovements(response[i]);
      }
    }
  }

  Future<void> saveImprovements(String Sports) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedImprovements = prefs.getStringList("improvements") ?? [];
    if (!savedImprovements.contains(Sports)) {
      savedImprovements.add(Sports);
      prefs.setStringList("improvements", savedImprovements);
      print("Improvement Saved");
    } else {
      print("Improvement is already saved");
    }
  }

  Future<bool> _hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('Name');
  }

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: !isLoading
            ? ListView(
                children: [
                  ListView.builder(
                      itemCount: response.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(value: return_response[index], onChanged: (value){
                          setState(() {
                            return_response[index] = value?? false;
                            handleButtonPress();
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
