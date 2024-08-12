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
  List<String> questions = ["How would you rate your muscle definition on a scale of 1 to 10, with 10 being very defined?",
    "What is your height in feet and inches?",
    "What is your current weight in pounds?",
    "How would you describe your ability to quickly change direction while running or moving?",
    "How would you rate your hand-eye coordination on a scale of 1 to 10, with 10 being excellent?",
    "How would you rate your overall speed and agility on a scale of 1 to 10, with 10 being very fast and agile?",
    "How well can you maintain balance while moving or performing complex tasks?",
    "How quickly can you react to sudden changes or surprises, on a scale of 1 to 10?",
    "How would you rate your ability to track and follow moving objects, such as a ball or a runner, on a scale of 1 to 10?",
    "How would you describe your overall cardiovascular endurance?",
    "How would you rate your ability to stay focused on a single task or goal without getting distracted, on a scale of 1 to 10?",
    "How would you rate your ability to quickly adapt to new skills or techniques on a scale of 1 to 10?",
    "How would you describe your overall strength compared to others your age?",
    "How would you rate your range of motion in your joints on a scale of 1 to 10, with 10 being very flexible?",
    "How would you describe your ability to control and coordinate fine movements, such as typing or playing a musical instrument?",
    "How would you rate your overall muscular strength on a scale of 1 to 10, with 10 being very strong?",
    "How well do you handle intense physical activity or exercise without getting tired quickly?",
    "How stable are your joints during physical activities, on a scale of 1 to 10, with 10 being very stable?",
    "How would you rate your aerobic capacity (endurance in activities like running or swimming) on a scale of 1 to 10?",
    "How would you rate your anaerobic threshold (ability to perform high-intensity activities) on a scale of 1 to 10?",
    "How would you rate your resilience (ability to bounce back from setbacks) on a scale of 1 to 10?",
    "How do you handle pressure during important events or competitions?",
    "How confident are you in your abilities when performing in front of others, on a scale of 1 to 10?",
    "How motivated are you to achieve your sports goals, on a scale of 1 to 10?",
    "How committed are you to your training routine, on a scale of 1 to 10?",
    "How well do you set and follow through with goals, on a scale of 1 to 10?",
    "How would you rate your ability to stay focused during training and competition, on a scale of 1 to 10?",
    "How well do you prepare mentally before a competition or important event, on a scale of 1 to 10?",
    "How do you manage distractions or interruptions during performance or training?",
    "How would you rate your perseverance in overcoming challenges or difficulties in sports, on a scale of 1 to 10?",
    "How quickly do you pick up new techniques or skills in sports or physical activities, on a scale of 1 to 10?",
    "How often do you consume a balanced diet that supports your physical activities?",
    "How well do you manage injury risks and recovery from injuries?",
    "How would you rate your current fitness level on a scale of 1 to 10?",
    "How do chronic health conditions impact your ability to participate in sports?",
    "How well do you understand the nutritional needs of your body for optimal performance?",
    "How easy is it for you to access sports facilities or gyms in your area?",
    "How accessible is sports training or coaching in your location?",
    "How would you rate your living environment in terms of supporting your sports activities, on a scale of 1 to 10?",
    "How does your current living condition affect your ability to train regularly?",
    "How supportive is your living situation for pursuing sports development opportunities?",
    "Do you have access to a sports psychologist or mental health support for athletes?",
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
    "How significant is the popularity of the sport in your decision to pursue it?"];
  List<TextEditingController> answersController = [];
  bool isLoading = false;

  _handleInitialMessage() {
  //   final prefs = await SharedPreferences.getInstance();
  //   String userPrompt = '''
  //       This is a list of most factors that might affect an individual's potential in each sport and how likely they will succeed. Use this list and create multiple questions to find the information listed. The requirement for the number of questions is listed after the list. The responses to the questions would be collected and further analyzed to determine the best-fit sport for them. Make sure to phrase all questions such that a person without any medical background would understand. For questions that need to be rated, make the rating on a scale of 10 (however do not make most questions on a scale). 1.Physical Attributes: Muscle Fiber Composition, Height, Weight, Leverage and Mechanical Advantage, Body Proportions, Strength Potential, Speed and Agility, Hand-Eye Coordination, Fine Motor Control, Tracking Moving Objects, Dynamic Balance, Lateral Quickness, Reaction Time and Reflexes, Visual Processing Speed, Auditory and Tactile Reaction, Cardiovascular Endurance, Aerobic Capacity, Anaerobic Threshold, Muscular Strength, Power, Range of Motion, Joint Stability 2.Psychological Factors: Resilience, Handling Pressure, Confidence and Self-Belief, Intrinsic/Extrinsic Motivation, Commitment to Training, Goal-Setting and Perseverance, Maintaining Focus, Attention to Detail, Mental Preparation 3.Skill Acquisition and Technique: Quick Adaptation 4.Nutrition and Physical Health: Nutrient Intake, Injury Risks, Rehabilitation, Fitness Levels, Impact of Chronic Conditions 5.Environmental Factors: Quality of Facilities, Suitable Equipment, Family Support, Community Influence, Training Environment, Regional Talent Pool  6.Living/Income situation: Access to facilities, Access to sports training, Access to sports development, Living environment/condition 7. Support: Sports Psychology, Physiotherapy and Medical Support 8. Competition and Exposure: Competitive Exposure, Progression Opportunities, Global Competition, Local vs. National Circuits 9. External Factors, Funding for Training, Balancing Priorities, Consistency in Training 10. Preference: Individual/Team, Competitive/recreational, Popularity, Physical Contact, Social/communication, Indoor/Outdoor, Top priority, Access to competitive environment,  Endurance/Intimate, Technical skill/Strength
  //   ''';
  //
  //   List<String> instructionPrompts = [
  //     "Please print 5 questions from physical attributes. Each question should correspond to one of the first 5 factors in physical attributes. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 more different questions from physical attributes. Each question should correspond to one of the second 5 factors in physical attributes. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 more different questions from physical attributes. Each question should correspond to one of the third 5 factors in physical attributes. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 more different questions from physical attributes. Each question should correspond to one of the fourth 5 factors in physical attributes. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 questions from psychological factors. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 more different questions from psychological factors. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 1 questions from skill acquisition. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 questions from nutrition and physical health. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 questions from Living/Income situation. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 2 questions from support network. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 3 questions from competition and exposure. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 4 questions from external factors. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 questions from preference. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text.",
  //     "Please print 5 more different questions questions from preference. Ensure the JSON is valid and looks like this: {questions: <list of questions>}. Only return the JSON format without any additional text."
  //   ];
  //
  //   for (String instructionPrompt in instructionPrompts) {
  //     await _fetchQuestions(userPrompt, instructionPrompt);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  // Future<void> _fetchQuestions(String userPrompt, String instructionPrompt) async {
  //   final request = ChatCompleteText(model: GptTurbo0631Model(), messages: [
  //     Messages(role: Role.user, content: userPrompt),
  //     Messages(role: Role.system, content: instructionPrompt)
  //   ]);
  //
  //   ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
  //   String result = response!.choices.first.message!.content.trim();
  //   print(result);
  //
    setState(() {
        // Map<String, dynamic> resultMap = Map<String, dynamic>.from(json.decode(result));
        questions.addAll(questions);
        answersController.addAll(List.generate(questions.length, (index) => TextEditingController()));
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
    // _openAI = OpenAI.instance.build(
    //     token: dotenv.env['OPENAI_API_KEY'],
    //     baseOption: HttpSetup(
    //       receiveTimeout: const Duration(seconds: 30),
    //     ));
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
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 5),
                            //   child: TextField(
                            //     decoration: InputDecoration(
                            //       hintText: "Type Your Answer Here",
                            //     ),
                            //     controller: answersController[index],
                            //     onChanged: (value) {},
                            //   ),
                            // )
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
