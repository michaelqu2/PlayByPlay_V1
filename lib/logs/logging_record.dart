import 'package:flutter/material.dart';
import '../profile/profile.dart';
import '../evaluateYourLevel/initial_questions_golf.dart';
import 'package:app_v1/unusedFiles/logging_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_v1/logs/sports_data.dart';

class LoggingRecordPage extends StatefulWidget {
  const LoggingRecordPage({super.key});

  @override
  State<LoggingRecordPage> createState() => _LoggingRecordPageState();
}

class _LoggingRecordPageState extends State<LoggingRecordPage> {
  String selectedSport = 'Golf';
  String selectedSwimmingStyle = '';
  Map<String, TextEditingController> textcontroller = {};

  @override
  void initState() {
    super.initState();
    _initializeTextControllers();
  }

  void _initializeTextControllers() {
    for (var field in sportsFields[selectedSport]!) {
      textcontroller[field] = TextEditingController();
    }
  }

  Future<void> saveLog() async {
    await addGolfLog();
    // Show a snack bar to notify log addition
    final snackBar = SnackBar(content: Text('Log is added'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> addSwimmingLog() async {
    DateTime date = DateTime.now();
    if (selectedSwimmingStyle.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {};
      String jsonLog = prefs.getString(selectedSport) ?? '{}';
      Map logs = jsonDecode(jsonLog);
      addSport(prefs);
      for (var field in sportsFields[selectedSport]!) {
        data[field] = textcontroller[field]?.text ?? '';
      }
      Map logMap = {};
      if (logs.containsKey(selectedSwimmingStyle)) {
        logMap = logs[selectedSwimmingStyle];
      }
      logMap[date.toString()] = data;
      logs[selectedSwimmingStyle] = logMap;
      prefs.setString(selectedSport, jsonEncode(logs));
    } else {
      return;
    }
  }

  Future<void> addGolfLog() async {
    DateTime date = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};

    // Get the logs from SharedPreferences and decode it
    String jsonLog = prefs.getString(selectedSport) ?? '{}';
    dynamic decodedLog = jsonDecode(jsonLog);

    // Initialize logs as an empty Map<String, dynamic> if it's not already a Map
    Map<String, dynamic> logs = {};

    if (decodedLog is Map) {
      // Cast the decoded log to Map<String, dynamic> explicitly
      logs = Map<String, dynamic>.from(decodedLog);
    } else if (decodedLog is List) {
      // Handle the case where the data is a List (unexpected structure)
      print("Unexpected List structure, converting to Map");
      // Convert the list to a map if necessary, or log a warning
    } else {
      // Handle any other unexpected data type
      print("Unexpected data structure: ${decodedLog.runtimeType}");
    }

    // Prepare data to add to logs
    for (var field in sportsFields[selectedSport]!) {
      data[field] = textcontroller[field]!.text;
    }

    // Add the new log entry
    logs[date.toString()] = data;

    // Save the updated logs back to SharedPreferences
    prefs.setString(selectedSport, jsonEncode(logs));
  }

  void addSport(SharedPreferences prefs) {
    List<String> sports = prefs.getStringList('sports') ?? [];
    if (!sports.contains(selectedSport)) {
      sports.add(selectedSport);
      prefs.setStringList('sports', sports);
    }
  }

  buildLoading() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        });
  }

  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Log'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage("assets/sports_background9.jpg"),
             fit: BoxFit.cover,
           ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSelectedSportDropDown(width),
                SizedBox(height: 20),
                if (selectedSport.isNotEmpty)
                  Column(children: [
                    selectedSport == 'Swimming'
                        ? buildSelectedSwimmingStyleDropDown(width)
                        : SizedBox(),
                    buildTextFields()
                  ]),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: saveLog,
                    child: Text('Add Log For ${selectedSport}'),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFields() {
    for (var field in sportsFields[selectedSport]!) {
      textcontroller[field] = TextEditingController();
    }
    return Column(
      children: sportsFields[selectedSport]!.map((field) {
        return Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(field),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: textcontroller[field],
                    decoration: InputDecoration(
                      hintText: "Enter ${field.split(' ')[0]}",
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildSelectedSportDropDown(width) {
    return Card(
        child: SizedBox(
      width: width * 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text('Select Sport'),
            DropdownButton<String>(
                value: selectedSport,
                items: sportsFields.keys
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSport = newValue!;
                    selectedSwimmingStyle = "";
                  });
                })
          ],
        ),
      ),
    ));
  }

  Card buildSelectedSwimmingStyleDropDown(width) {
    return Card(
        child: SizedBox(
      width: width * 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text('Select Swimming style'),
            DropdownButton<String>(
                value: selectedSwimmingStyle,
                items: swimmingStyles
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSwimmingStyle = newValue!;
                  });
                })
          ],
        ),
      ),
    ));
  }
}
