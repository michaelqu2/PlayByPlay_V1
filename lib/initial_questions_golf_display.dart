import 'package:flutter/material.dart';
import '/profile.dart';
import '/home.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/selection.dart';
import 'dart:convert';

class InitialQuestionsGolfDisplayPage extends StatefulWidget {
  const InitialQuestionsGolfDisplayPage({super.key, required this.questions, required this.answers});

  final List<String> questions;
  final List<String> answers;


  @override
  State<InitialQuestionsGolfDisplayPage> createState() =>
      _InitialQuestionsGolfDisplayPageState();
}

class _InitialQuestionsGolfDisplayPageState extends State<InitialQuestionsGolfDisplayPage> {
  late final OpenAI _openAI;
  String? GPTresponse;
  List<String> response = [];
  bool isLoading = true;

  Future<void> _handleInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String userPrompt = 'I am a ${prefs.getString('selected_gender')}. I play ${prefs
        .getString('selected_sport1')}. I am a ${prefs.getString(
        'selected_level')}.';
    String instructionPrompt = "Base off the ${widget.questions} and ${widget.answers} received, provide three aspects of my game that I should be improving on. Please make sure that you only return a JSON format that look like this: {Improvements: <list of improvements>}. Ensure the JSON is valid and do not write anything before or after the JSON structure provided.";
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
    ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
    setState(() {
      String result = response!.choices.first.message!.content.trim();
      print(result);
      try {
        Map<String, dynamic> resultMap = Map<String, dynamic>.from(
            json.decode(result));
        // response = List<String>.from(resultMap['sports']);
        isLoading = false;
      } catch (e) {
        print("Error Parsing JSON $e");
      }
    });
    // print(result);

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
        // child: !isLoading
        //     ? ListView(
        //   children: [
        //     ListView.builder(
        //         itemCount: questions.length,
        //         physics: ClampingScrollPhysics(),
        //         shrinkWrap: true,
        //         itemBuilder: (context, index) {
        //           return Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text("Question ${index + 1}: ${questions[index]}"),
        //               Padding(
        //                 padding: const EdgeInsets.only(bottom: 5),
        //                 child: TextField(
        //                   decoration: InputDecoration(
        //                     hintText: "Type Your Answer Here",
        //                   ),
        //                   controller: answersController[index],
        //                   onChanged: (value) {},
        //                 ),
        //               )
        //             ],
        //           );
        //         }),
        //     ElevatedButton(
        //         onPressed: () {
        //           List<String> saved_answers = getAnswers();
        //           print(saved_answers);
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) =>
        //                     InitialQuestionsGolfDisplayPage(
        //                         questions: questions,
        //                         answers: saved_answers)),
        //           ).then((value) => Navigator.pop(context));
        //         },
        //         child: const Text("Get Suggestion"))
        //   ],
        // )
        //     : Center(
        //   child: Container(
        //     margin: const EdgeInsets.all(5),
        //     child: CircularProgressIndicator(),
        //   ),
        // ),
      ),
    );
  }
}
