import 'package:flutter/material.dart';
import 'question_long_choice.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(QuestionLongTestPage());
}

class QuestionLongTestPage extends StatefulWidget {
  const QuestionLongTestPage({super.key});

  @override
  State<QuestionLongTestPage> createState() => _QuestionLongTestPageState();
}

class _QuestionLongTestPageState extends State<QuestionLongTestPage> {
  final List<Map<String, String>> data = [
    {"Category": "General Information", "Test/Measurement": "Name:"},
    {"Category": "", "Test/Measurement": "Age:"},
    {"Category": "", "Test/Measurement": "Gender:"},
    {"Category": "", "Test/Measurement": "Height (cm):"},
    {"Category": "", "Test/Measurement": "Weight (lbs):"},

    {"Category": "Muscular Strength", "Test/Measurement": "Max Bench Press (lbs)"},
    {"Category": "", "Test/Measurement": "Max Squat (lbs)"},
    {"Category": "", "Test/Measurement": "Handgrip Strength"},

    {"Category": "Muscular Endurance", "Test/Measurement": "Push-Up Test."},
    {"Category": "", "Test/Measurement": "Sit-Up Test (1 min)"},
    {"Category": "", "Test/Measurement": "Planks Test"},

    {"Category": "Muscular Power", "Test/Measurement": "Vertical Jump Height"},
    {"Category": "", "Test/Measurement": "Standing Broad Jump"},

    {"Category": "Agility", "Test/Measurement": "100 Meter Sprint:"},
    {"Category": "", "Test/Measurement": "400 Meter Time"},
    {"Category": "", "Test/Measurement": "5-10-5 Shuttle Run"},

    {"Category": "Aerobic Capacity", "Test/Measurement": "VO2 Max Test"},
    {"Category": "", "Test/Measurement": "1 Mile Run"},
    {"Category": "", "Test/Measurement": "Talk Without Breath Test"},

    {"Category": "Flexibility", "Test/Measurement": "Sit and Reach Test"},

    {"Category": "Balance and Stability", "Test/Measurement": "One-Leg Balance Test"},

    {"Category": "Reaction Time Test", "Test/Measurement": "Hand Reaction Time."},
    {"Category": "", "Test/Measurement": "Foot Reaction Time"},



  ];

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var row in data) {
      _controllers[row['Test/Measurement']!] = TextEditingController();
    }
  }


  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Sheet'),
        ),
        body: Column(
          children: [
            Expanded(
              child: DataSheet(data: data, controllers: _controllers),
            ),
            ElevatedButton(
              onPressed: () {
                _saveData();
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => const QuestionLongChoicePage()));
              },
              child: Text('Save'), // The child parameter should be here
            ),
            ElevatedButton(
              onPressed: () {
                _printTestData();
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => const QuestionLongChoicePage()));
              },
              child: Text('print'), // The child parameter should be here
            ),
          ],
        ),
      ),
    );
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the test names
    List<String> testList = data.map((row) => row['Test/Measurement']!)
        .toList();
    await prefs.setStringList('Long Test', testList);

    // Save the test inputs
    List<String> testInputList = _controllers.values.map((
        controller) => controller.text).toList();
    await prefs.setStringList('Long Test Input', testInputList);

    bool isLongTest = true;
    await prefs.setBool('Long Test Check', isLongTest);


    print("Data saved successfully!");
  }
}

void _printTestData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? testList = prefs.getStringList('Long Test');
  List<String>? testOutputList = prefs.getStringList('Long Test Input');

  if (testList != null && testOutputList != null) {
    for (int i = 0; i < testList.length; i++) {
      print(testList[i]+ testOutputList[i]);
    }
  }
}

class DataSheet extends StatelessWidget {
  final List<Map<String, String>> data;
  final Map<String, TextEditingController> controllers;

  const DataSheet({required this.data, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 0,
        columns: [
          DataColumn(
            label: Text(''),
            numeric: false,
          ),
          DataColumn(label: Text('Test/Measurement')),
          DataColumn(label: Text('Input')),
        ],
        rows: _buildRows(context),
      ),
    );
  }

  List<DataRow> _buildRows(BuildContext context) {
    List<DataRow> rows = [];
    String? currentCategory;

    for (var row in data) {
      String testMeasurement = row['Test/Measurement']!;

      if (row['Category'] != currentCategory) {
        currentCategory = row['Category'];
        if (currentCategory?.isNotEmpty == true) {
          rows.add(DataRow(
            cells: [
              DataCell(Text('')),
              DataCell(
                Container(
                  padding: EdgeInsets.only(top: 0, bottom: 0),
                  child: Text(
                    currentCategory!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataCell(Text('')),
            ],
          ));
        }
      }

      rows.add(DataRow(cells: [
        DataCell(
          Container(
            padding: EdgeInsets.only(left: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 0),
              ],
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              Expanded(
                child: Text(testMeasurement),
              ),
              IconButton(
                icon: Icon(Icons.info, size: 20),
                onPressed: () {
                  _showInstructions(context, testMeasurement);
                },
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
        DataCell(
          Container(
            width: 125,
            height: 40,
            child: TextField(
              controller: controllers[testMeasurement],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter result',
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ]));
    }

    return rows;
  }

  void _showInstructions(BuildContext context, String test) {
    final instructions = {
      "Name:": "Enter your full name.",
      "Age:": "Enter your age.",
      "Gender:": "Select your gender.",
      "Height (cm/in):": "Measure your height in centimeters or inches.",
      "Weight (kg/lbs):": "Measure your weight in kilograms or pounds.",
      "Push-Ups Test": "Perform as many push-ups as possible without stopping.",
      "Squats Test": "Perform as many squats as possible within a set time frame.",
      "Planks Test": "Hold a plank position for as long as possible while maintaining proper form.",
      "Running Performance": "Complete a running test, such as a timed mile or sprint, and record your performance.",
      "Body Composition (BIA)": "Use a body composition analyzer to measure your body fat percentage and muscle mass.",
      "Reaction Time Test": "Use a reaction time tool to measure the time it takes for you to respond to a visual or auditory stimulus.",
      "Agility T-Test": "Perform the T-test, running between cones arranged in a 'T' shape as quickly as possible.",
      "Illinois Agility Test": "Run through an obstacle course of cones laid out in a specific pattern to assess agility.",
      "Lateral Change of Direction Test": "Move side-to-side as quickly as possible between markers in this test of lateral agility.",
      "Online Reaction Time Tests": "Complete an online test to measure your reaction time to visual or auditory cues.",
      "Jump and Landing Test": "Perform a vertical or broad jump, then focus on landing with good balance and control.",
      "One-Leg Stand Test": "Stand on one leg for as long as possible to assess your balance and stability.",
      "Cooper Test": "Run as far as possible in 12 minutes; typically performed on a track or treadmill.",
      "One-Rep Max": "Perform a single maximum lift for a given exercise (e.g., bench press, squat).",
      "Handgrip Strength": "Use a handgrip dynamometer to measure your grip strength.",
      "Vertical Jump": "Perform a vertical jump and measure the height you reach.",
      "Sit and Reach Test": "Sit with your legs extended and reach as far forward as possible to see if you can touch toe",
      "Joint Range of Motion": "Use a goniometer or similar tool to measure the range of motion of a joint (e.g., knee, elbow).",
      "Functional Movement Screen": "Perform a series of functional movements to assess mobility, stability, and coordination.",
      "Standing Broad Jump": "Jump as far forward as possible from a standing position.",
      "Wall Sit Test": "Hold a seated position with your back against the wall for as long as possible.",
      "5-10-5 Shuttle Run": "Run 5 yards, touch the line, run back 10 yards, and then return 5 yards as fast as possible.",
      "Talk Test": "Perform aerobic exercise to assess how long you can talk without stopping",
      "HIIT Performance": "Complete a high-intensity interval training (HIIT) session and measure your performance (e.g., number of intervals completed, intensity).",
    };

    final instruction = instructions[test];
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Instructions'),
            content: Text(instruction ?? 'No instructions available'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }
}