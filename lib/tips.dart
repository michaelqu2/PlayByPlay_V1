import 'package:flutter/material.dart';
import '/profile.dart';
import '/home.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/selection.dart';
import 'dart:convert';
import 'initial_questions_golf_display.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late final OpenAI _openAI;
  String? Tips;
  bool isLoading = true;

  Future<void> _handleInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String userPrompt =
        'Can you rewrite ${prefs.getStringList("Improvements")} as one long string with bullet points';
    final request = ChatCompleteText(model: GptTurbo0631Model(), messages: [
      Messages(
        role: Role.user,
        content: userPrompt,
      ),
    ]);
    ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
    Tips = response!.choices.first.message!.content;
    setState(() {
      prefs.setString("tips", Tips!);
      isLoading = false;
    });
    // print(result);
  }

  @override
  void initState() {
    _openAI = OpenAI.instance.build(
        token: dotenv.env['OPENAI_API_KEY'],
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 30),
        ));
    _handleInitialMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: !isLoading
            ? ListView(
                children: [
                  ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [Text(Tips!)],
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
