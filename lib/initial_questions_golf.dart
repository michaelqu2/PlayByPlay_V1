import 'package:flutter/material.dart';
import '/profile.dart';
import '/home.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialQuestionsGolfPage extends StatefulWidget {
  const InitialQuestionsGolfPage({super.key});

  @override
  State<InitialQuestionsGolfPage> createState() =>
      _InitialQuestionsGolfPageState();
}

class _InitialQuestionsGolfPageState extends State<InitialQuestionsGolfPage> {
  late final OpenAI _openAI;

  Future<void> _handleInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String instructionPrompt =
        "Hi my name is ${prefs.getString('Name')}, what is 1+1";
    print(instructionPrompt);
    final request = ChatCompleteText(model: GptTurbo0631Model(), messages: [
      Messages(
        role: Role.system,
        content: instructionPrompt,
      )
    ]);
    ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
    print(response);
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
      body: const Center(
        child: Column(
          children: [
            Text("Home Page"),
          ],
        ),
      ),
    );
  }
}
