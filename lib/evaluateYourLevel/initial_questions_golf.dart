import 'package:app_v1/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'initial_questions_golf_display.dart';

class InitialQuestionsGolfPage extends StatefulWidget {
  const InitialQuestionsGolfPage({super.key});

  @override
  State<InitialQuestionsGolfPage> createState() =>
      _InitialQuestionsGolfPageState();
}

class _InitialQuestionsGolfPageState extends State<InitialQuestionsGolfPage> {
  late final OpenAI _openAI;
  String? GPTresponse;
  List<String> questions = [];
  List<TextEditingController> answersController = [];
  bool isLoading = true;

  Future<void> _handleInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String userPrompt =
        'I play ${prefs.getString('selected_sport1')}. I am a ${prefs.getString('selected_level')}.';
    String instructionPrompt =
        "can you ask me 4 questions base off my information that will help to accurately determine my level in a more specific ways. And these questions should also determines my biggest weakness in my game that need to be improved. Please make sure that you only return a JSON format that look like this: {questions: <list of questions>}. Ensure the JSON is valid and do not write anything before or after the JSON structure provided.";
    print(instructionPrompt);
    final request = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: [
        {
          "role": "user",
          "content": userPrompt,
        },
        {
          "role": "system",
          "content": instructionPrompt,
        }
      ],
    );
    ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
    String result = response!.choices.first.message!.content.trim();
    print(result);
    getQuestions(result);
  }

  getQuestions(String results) {
    setState(() {
      try {
        Map<String, dynamic> resultMap =
            Map<String, dynamic>.from(json.decode(results.toString()));
        questions = List<String>.from(resultMap['questions']);
        answersController =
            List.generate(questions.length, (index) => TextEditingController());
        isLoading = false;
      } catch (e) {
        print("Error Parsing JSON $e");
        showAlertDialogue(context);
      }
    });
  }

  getAnswers() {
    List<String> answers = [];
    for (int i = 0; i < answersController.length; i++) {
      answers.add(answersController[i].text);
    }
    return answers;
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
                      _handleInitialMessage();
                    },
                    child: const Text("Run Again"))
              ]);
        });
  }

  // Future<bool> _hasProfile() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.containsKey('Name');
  // }

  @override
  void initState() {
    _openAI = OpenAI.instance.build(
        token: dotenv.env['OPENAI_API_KEY'],
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 30),
        ));
    // _hasProfile().then((value) {
    //   if (value) {
    //     _handleInitialMessage();
    //   } else {
    //     print("ERROR");
    //   }
    // });
    _handleInitialMessage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: color2,
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
                                onChanged: (value) {},
                              ),
                            )
                          ],
                        );
                      }),
                  ElevatedButton(
                      onPressed: () {
                        List<String> saved_answers = getAnswers();
                        print(saved_answers);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InitialQuestionsGolfDisplayPage(
                                      questions: questions,
                                      answers: saved_answers)),
                        );
                      },
                      child: const Text("Get Suggestion"))
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
