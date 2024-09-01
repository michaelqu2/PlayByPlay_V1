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
    {"Category": "", "Test/Measurement": "Height (cm/in):"},
    {"Category": "", "Test/Measurement": "Weight (kg/lbs):"},
    {"Category": "Physical Attributes", "Test/Measurement": "Push-Ups Test"},
    {"Category": "", "Test/Measurement": "Squats Test"},
    {"Category": "", "Test/Measurement": "Planks Test"},
    {"Category": "", "Test/Measurement": "Running Performance"},
    {"Category": "", "Test/Measurement": "Body Composition (BIA)"},
    {
      "Category": "Motor Skills and Coordination",
      "Test/Measurement": "Reaction Time Test"
    },
    {"Category": "", "Test/Measurement": "Agility T-Test"},
    {"Category": "", "Test/Measurement": "Illinois Agility Test"},
    {"Category": "", "Test/Measurement": "Lateral Change of Direction Test"},
    {"Category": "", "Test/Measurement": "Online Reaction Time Tests"},
    {"Category": "", "Test/Measurement": "Jump and Landing Test"},
    {"Category": "", "Test/Measurement": "One-Leg Stand Test"},
    {"Category": "Physical Fitness", "Test/Measurement": "Cooper Test"},
    {"Category": "", "Test/Measurement": "One-Rep Max"},
    {"Category": "", "Test/Measurement": "Handgrip Strength"},
    {"Category": "", "Test/Measurement": "Vertical Jump"},
    {"Category": "", "Test/Measurement": "Sit and Reach Test"},
    {"Category": "", "Test/Measurement": "Joint Range of Motion"},
    {"Category": "", "Test/Measurement": "Functional Movement Screen"},
    {"Category": "", "Test/Measurement": "Standing Broad Jump"},
    {"Category": "", "Test/Measurement": "Wall Sit Test"},
    {"Category": "", "Test/Measurement": "5-10-5 Shuttle Run"},
    {"Category": "", "Test/Measurement": "Talk Test"},
    {"Category": "", "Test/Measurement": "HIIT Performance"},
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
                _printTestData();
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => const QuestionLongChoicePage()));
              },
              child: Text('Save'), // The child parameter should be here
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
      // ... add other instructions here ...
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