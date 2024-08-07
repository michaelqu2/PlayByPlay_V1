import 'package:flutter/material.dart';

void main() {
  runApp(QuestionLongTestPage());
}

class QuestionLongTestPage extends StatefulWidget {
  const QuestionLongTestPage({super.key});

  @override
  State<QuestionLongTestPage> createState() => _QuestionLongTestPageState();
}

class _QuestionLongTestPageState extends State<QuestionLongTestPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Sheet'),
        ),
        body: DataSheet(),
      ),
    );
  }
}

class DataSheet extends StatelessWidget {
  final List<Map<String, String>> data = [
    {"Category": "General Information", "Test/Measurement": "Name:"},
    {"Category": "", "Test/Measurement": "Date:"},
    {"Category": "", "Test/Measurement": "Age:"},
    {"Category": "", "Test/Measurement": "Gender:"},
    {"Category": "", "Test/Measurement": "Height (cm/in):"},
    {"Category": "", "Test/Measurement": "Weight (kg/lbs):"},
    {"Category": "Physical Attributes", "Test/Measurement": "Push-Ups Test"},
    {"Category": "", "Test/Measurement": "Squats Test"},
    {"Category": "", "Test/Measurement": "Planks Test"},
    {"Category": "", "Test/Measurement": "Running Performance"},
    {"Category": "", "Test/Measurement": "Height Measurement"},
    {"Category": "", "Test/Measurement": "Weight Measurement"},
    {"Category": "", "Test/Measurement": "Body Composition (BIA)"},
    {"Category": "Motor Skills and Coordination", "Test/Measurement": "Reaction Time Test"},
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

  final Map<String, String> instructions = {
    "Name:": "Enter your full name.",
    "Date:": "Enter the current date.",
    "Age:": "Enter your age.",
    "Gender:": "Select your gender.",
    "Height (cm/in):": "Measure your height in centimeters or inches.",
    "Weight (kg/lbs):": "Measure your weight in kilograms or pounds.",
    "Muscle Fiber Composition - Push-Ups": "Do as many push-ups as you can in one go. Count the reps.",
    "Muscle Fiber Composition - Squats": "Do as many squats as you can in one go. Count the reps.",
    "Muscle Fiber Composition - Planks": "Hold a plank position as long as you can. Record the time in seconds.",
    "Bone Density - Running Performance": "Run a specified distance and record the time in minutes per kilometer.",
    "Height Measurement": "Measure your height.",
    "Weight Measurement": "Measure your weight.",
    "Body Composition (BIA)": "Measure body composition using Bioelectrical Impedance Analysis (BIA).",
    "Reaction Time Test": "Perform a reaction time test. Record the reaction time.",
    "Agility T-Test": "Perform the T-Test for agility. Record the time.",
    "Illinois Agility Test": "Perform the Illinois Agility Test. Record the time.",
    "Lateral Change of Direction Test": "Perform the Lateral Change of Direction Test. Record the time.",
    "Online Reaction Time Tests": "Perform online reaction time tests. Record the results.",
    "Jump and Landing Test": "Perform a jump and landing test. Record the results.",
    "One-Leg Stand Test": "Perform the One-Leg Stand Test. Record the time.",
    "Cooper Test": "Perform the Cooper Test for endurance. Record the distance covered.",
    "One-Rep Max": "Determine your one-repetition maximum for strength exercises.",
    "Handgrip Strength": "Measure handgrip strength using a dynamometer.",
    "Vertical Jump": "Perform a vertical jump. Measure and record the height jumped.",
    "Sit and Reach Test": "Perform the Sit and Reach Test for flexibility. Record the distance reached.",
    "Joint Range of Motion": "Measure joint range of motion for specific joints.",
    "Functional Movement Screen": "Perform the Functional Movement Screen. Record the results.",
    "Standing Broad Jump": "Perform the Standing Broad Jump. Measure and record the distance jumped.",
    "Wall Sit Test": "Perform the Wall Sit Test. Record the time.",
    "5-10-5 Shuttle Run": "Perform the 5-10-5 Shuttle Run. Record the time.",
    "Talk Test": "Perform the Talk Test during exercise. Record observations.",
    "HIIT Performance": "Perform and record results from High-Intensity Interval Training (HIIT).",
  };

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
      if (row['Category'] != currentCategory) {
        // Add a separator row if the category changes
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

      // Add the test/measurement row
      rows.add(DataRow(cells: [
        DataCell(
          Container(
            padding: EdgeInsets.only(left: 0), // Adjust padding to push the icon closer to the left
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.info, size: 20),
                  onPressed: () {
                    _showInstructions(context, row['Test/Measurement'] ?? '');
                  },
                ),
                SizedBox(width: 0), // Adds a small space between the icon and text
              ],
            ),
          ),
        ),
        DataCell(Container(
          width: 150, // Adjust width for the Test/Measurement column
          child: Text(row['Test/Measurement'] ?? ''),
        )),
        DataCell(
          Container(
            width: 150, // Adjust width for the Input column
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter result',
              ),
            ),
          ),
        ),
      ]));
    }

    return rows;
  }

  void _showInstructions(BuildContext context, String test) {
    final instruction = instructions[test];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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