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

class QuestionShortPage extends StatefulWidget {
  const QuestionShortPage({super.key});

  @override
  State<QuestionShortPage> createState() => _QuestionShortPageState();
}

class _QuestionShortPageState extends State<QuestionShortPage> {
  late final OpenAI _openAI;
  String? GPTresponse;
  List<String> questions = [];
  List<TextEditingController> answersController = [];
  bool isLoading = true;

  Future<void> _handleInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String userPrompt = '''
        This is a list of almost every single factors and aspects that might affect an individuals potential in each sports and how likely they will succeed. 
        Use this list and create multiple questions that include all these factors for the users to help to determine all the best sports that might fit them base on these factors.      
 1. Physical Attributes
    Genetics and Body Type:
    •	Muscle Fiber Composition:
    •	Fast-Twitch vs. Slow-Twitch Fibers
    •	Intermediate Fibers
    •	Height, Weight, Bone Structure:
    •	Leverage and Mechanical Advantage
    •	Body Proportions
    •	Genetic Predispositions:
    •	Strength Potential
    •	Speed and Agility
    Motor Skills and Coordination:
    •	Hand-Eye Coordination:
    •	Fine Motor Control
    •	Tracking Moving Objects
    •	Footwork and Agility:
    •	Dynamic Balance
    •	Lateral Quickness
    •	Reaction Time and Reflexes:
    •	Visual Processing Speed
    •	Auditory and Tactile Reaction
    Physical Fitness:
    •	Cardiovascular Endurance:
    •	Aerobic Capacity
    •	Anaerobic Threshold
    •	Strength:
    •	Muscular Strength
    •	Power
    •	Flexibility and Joint Mobility:
    •	Range of Motion
    •	Joint Stability
    2. Psychological Factors
    Mental Toughness:
    •	Resilience
    •	Handling Pressure
    •	Confidence and Self-Belief
    Motivation and Dedication:
    •	Intrinsic vs. Extrinsic Motivation
    •	Commitment to Training
    •	Goal-Setting and Perseverance
    Concentration and Focus:
    •	Maintaining Focus
    •	Attention to Detail
    •	Mental Preparation
    3. Skill Acquisition and Technique
    Adaptability and Learning Capacity:
    •	Quick Adaptation
    •	Coachability
    •	Learning from Mistakes
    4. Nutrition and Physical Health
    Dietary Habits:
    •	Nutrient Intake
    •	Hydration
    Injury Prevention and Recovery:
    •	Understanding Injury Risks
    •	Rehabilitation
    General Physical Health:
    •	Fitness Levels
    •	Impact of Chronic Conditions
    5. Environmental Factors
    Access to Facilities and Equipment:
    •	Quality of Facilities
    •	Suitable Equipment
    Social and Cultural Support:
    •	Family Support
    •	Community Influence
    Geographical and Climate Considerations:
    •	Training Environment
    •	Regional Talent Pool
    6. Coaching and Support Network
    Quality of Coaching:
    •	Expertise and Experience
    •	Individualized Programs
    Team Dynamics (if applicable):
    •	Cohesion and Communication
    •	Leadership Dynamics
    Support Services:
    •	Sports Psychology
    •	Physiotherapy and Medical Support
    7. Competition and Exposure
    Level of Competition Faced:
    •	Competitive Exposure
    •	Progression Opportunities
    Performance Evaluation:
    •	Objective Feedback
    •	Benchmarking Against Peers
    International vs. Domestic Exposure:
    •	Global Competition
    •	Local vs. National Circuits
    8. External Factors
    Financial Resources:
    •	Funding for Training
    •	Sponsorship and Endorsements
    Time Commitment:
    •	Balancing Priorities
    •	Consistency in Training
    Regulatory and Governance Factors:
    •	Compliance with Regulations
    •	Impact of Policy Changes
    ''';

    List<String> instructionPrompts = [
      "Please print 5 questions from physical attributes. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 5 more different questions from physical attributes. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 5 more different questions from physical attributes. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 5 questions from psychological factors. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 5 more different questions from psychological factors. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 3 questions from skill acquisition. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 6 questions from nutrition and physical health. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 2 questions from support network. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 4 questions from competition and exposure. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
      "Please print 6 questions from external factors. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text."
    ];
    for (String instructionPrompt in instructionPrompts) {
      await _fetchQuestions(userPrompt, instructionPrompt);
    }
    setState(() {
      isLoading = false;
    });
  }
  Future<void> _fetchQuestions(String userPrompt, String instructionPrompt) async {
    final request = ChatCompleteText(model: GptTurbo0631Model(), messages: [
      Messages(role: Role.user, content: userPrompt),
      Messages(role: Role.system, content: instructionPrompt)
    ]);

    ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
    String result = response!.choices.first.message!.content.trim();
    print(result);

    setState(() {
      try {
        Map<String, dynamic> resultMap = Map<String, dynamic>.from(json.decode(result));
        questions.addAll(List<String>.from(resultMap['questions']));
        answersController.addAll(List.generate(resultMap['questions'].length, (index) => TextEditingController()));
      } catch (e) {
        print("Error Parsing JSON $e");
        showAlertDialogue(context);
      }
    });
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
                      _handleInitialMessage();
                    },
                    child: const Text("Run Again"))
              ]);
        });
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InitialQuestionsGolfDisplayPage(
                                      questions: questions,
                                      answers: saved_answers)),
                        ).then((value) => Navigator.pop(context));
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
