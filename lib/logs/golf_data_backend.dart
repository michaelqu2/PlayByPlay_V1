import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class GolfDataBackendPage extends StatefulWidget {
  const GolfDataBackendPage({super.key});

  @override
  State<GolfDataBackendPage> createState() => _GolfDataBackendPageState();
}

class _GolfDataBackendPageState extends State<GolfDataBackendPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  String result = '';
  String averageScore = '';
  String averageDistance = '';
  String fairwayAvg = '';
  String greenInRegAvg = '';
  String greenInRegOnFairwayAvg = '';
  String greenInRegOffAvg = ''; // Added for off fairway greens
  String birdieConversionAvg = ''; // Added for birdie conversion rate
  String puttsHoleAvg = ''; // Added for putts per hole
  String puttsAvg = '';
  String threePuttsAvg = '';
  String scramblingAttemptAvg = '';
  String scramblingAttemptBunkerAvg = '';
  String scramblingAttemptRoughAvg = ''; // Added for scrambling from rough
  List<Map<String, dynamic>> logs = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? logsJson = prefs.getString('Golf');

    if (logsJson != null) {
      dynamic decodedData = jsonDecode(logsJson);

      if (decodedData is Map<String, dynamic>) {
        setState(() {
          logs = decodedData.entries
              .map((entry) => {
                    'logDate': entry.key as String,
                    ...entry.value as Map<String, dynamic>,
                  })
              .toList();
        });
      } else if (decodedData is List) {
        setState(() {
          logs = List<Map<String, dynamic>>.from(decodedData);
        });
      } else {
        print("Unexpected data format");
      }
    }
  }

  Future<void> _saveLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Safeguard: Ensure logs are a list of maps
    if (logs is List<Map<String, dynamic>>) {
      prefs.setString('Golf', jsonEncode(logs));
    } else {
      // If logs somehow turned into an unexpected format, reset it
      setState(() {
        logs = [];
      });
    }
  }

  Future<void> _deleteLog(int index) async {
    setState(() {
      logs.removeAt(index);
    });
    await _saveLogs();
  }

  Future<void> _predict() async {
    setState(() {
      isLoading = true;
    });

    final double? input1 = double.tryParse(averageDistance);
    final double? input2 = double.tryParse(fairwayAvg);
    final double? input3 = double.tryParse(greenInRegAvg);
    final double? input4 = double.tryParse(greenInRegOnFairwayAvg);
    final double? input5 = double.tryParse(greenInRegOnFairwayAvg);
    final double? input6 = double.tryParse(birdieConversionAvg);
    final double? input7 = double.tryParse(puttsAvg);
    final double? input8 = double.tryParse(threePuttsAvg);
    final double? input9 = double.tryParse(scramblingAttemptAvg);
    final double? input10 = double.tryParse(scramblingAttemptBunkerAvg);
    final double? input11 = double.tryParse(scramblingAttemptRoughAvg);

    if (input1 == null ||
        input2 == null ||
        input3 == null ||
        input4 == null ||
        input5 == null ||
        input6 == null ||
        input7 == null ||
        input8 == null ||
        input9 == null ||
        input10 == null ||
        input11 == null) {
      setState(() {
        result = "Please enter valid numbers for all fields.";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$URL/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'inputs': [
            input1,
            input2,
            input3,
            input4,
            input5,
            input6,
            input7,
            input8,
            input9,
            input10,
            input11
          ],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          result =
              'Golf Performance Predictor: ${data['prediction'].toStringAsFixed(2)}'; // Display the prediction
          isLoading = false;
        });
      } else {
        setState(() {
          result = "Error: ${response.reasonPhrase}";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        result = "Error: Could not connect to the server.";
        isLoading = false;
      });
    }
  }

  Future<void> calculateAverages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? logsJson = prefs.getString('Golf');

    if (logsJson != null) {
      try {
        dynamic logsData = jsonDecode(logsJson);

        if (logsData is Map<String, dynamic>) {
          // Handle Map case (like originally expected)
          Map<String, dynamic> logs = logsData;
          processLogsForAverages(logs);
        } else if (logsData is List) {
          // Handle List case
          for (var entry in logsData) {
            if (entry is Map<String, dynamic>) {
              processLogsForAverages(entry);
            }
          }
        } else {
          print("Unexpected data format: $logsData");
        }
      } catch (e) {
        print("Error calculating averages: $e");
      }
    } else {
      // No data
      setState(() {
        averageScore = "No data";
        averageDistance = "No data";
        fairwayAvg = "No data";
        greenInRegAvg = "No data";
        greenInRegOnFairwayAvg = "No data";
        puttsAvg = "No data";
        threePuttsAvg = "No data";
        scramblingAttemptAvg = "No data";
        scramblingAttemptBunkerAvg = "No data";
        birdieConversionAvg = "No data";
        puttsHoleAvg = "No data";
        greenInRegOffAvg = "No data";
        scramblingAttemptRoughAvg = "No data";
      });
    }
  }

// New helper function to process logs and calculate averages
  void processLogsForAverages(Map<String, dynamic> logs) {
    List<double> scores = [];
    List<double> drive_distances = [];
    List<double> fairway_hit = [];
    List<double> green_in_regulation = [];
    List<double> green_in_regulation_on = [];
    List<double> green_in_regulation_off = [];
    List<double> birdie_conversion = [];
    List<double> number_of_putts = [];
    List<double> putts_hole = [];
    List<double> number_of_3putts = [];
    List<double> scrambling_attempt = [];
    List<double> scrambling_attempt_bunker = [];
    List<double> scrambling_attempt_rough = [];

    logs.forEach((key, value) {
      if (value.containsKey('Score')) {
        scores.add(double.tryParse(value['Score']) ?? 0.0);
      }
      if (value.containsKey('Drive Distance')) {
        drive_distances.add(double.tryParse(value['Drive Distance']) ?? 0.0);
      }
      if (value.containsKey('Fairway Hit')) {
        fairway_hit
            .add((double.tryParse(value['Fairway Hit']) ?? 0.0) / 14 * 100);
      }
      if (value.containsKey('Green in regulation')) {
        green_in_regulation.add(
            (double.tryParse(value['Green in regulation']) ?? 0.0) / 18 * 100);
      }
      if (value.containsKey('Green in Regulation on the fairway')) {
        green_in_regulation_on.add(
            (double.tryParse(value['Green in Regulation on the fairway']) ??
                    0.0) /
                (double.tryParse(value['Fairway Hit']) ?? 0.0) *
                100);
      }
      if (value.containsKey('Green in Regulation on the fairway')) {
        green_in_regulation_off.add(
            ((double.tryParse(value['Green in regulation']) ?? 0.0) -
                    (double.tryParse(
                            value['Green in Regulation on the fairway']) ??
                        0.0)) /
                (14 - (double.tryParse(value['Fairway Hit']) ?? 0.0)) *
                100);
      }
      if (value.containsKey('# of Putts')) {
        number_of_putts.add(double.tryParse(value['# of Putts']) ?? 0.0);
      }
      if (value.containsKey('# of Birdies')) {
        birdie_conversion.add((double.tryParse(value['# of Birdies']) ?? 0.0) /
            (double.tryParse(value['Green in regulation']) ?? 0.0) *
            100);
      }
      if (value.containsKey('# of Putts')) {
        putts_hole.add((double.tryParse(value['# of Putts']) ?? 0.0) /
            (double.tryParse(value['Green in regulation']) ?? 0.0));
      }
      if (value.containsKey('# of 3 Putts')) {
        number_of_3putts.add(double.tryParse(value['# of 3 Putts']) ?? 0.0);
      }
      if (value.containsKey('Scrambling Attempts') &&
          value.containsKey('Scrambling Success')) {
        scrambling_attempt.add(
            (double.tryParse(value['Scrambling Success']) ?? 0.0) /
                (double.tryParse(value['Scrambling Attempts']) ?? 0.0) *
                100);
      }
      if (value.containsKey('Scrambling Attempts in Bunker') &&
          value.containsKey('Scrambling Success in Bunker')) {
        scrambling_attempt_bunker.add(
            (double.tryParse(value['Scrambling Success in Bunker']) ?? 0.0) /
                (double.tryParse(value['Scrambling Attempts in Bunker']) ??
                    0.0) *
                100);
      }
      if (value.containsKey('Scrambling Attempts') &&
          value.containsKey('Scrambling Success') &&
          value.containsKey('Scrambling Attempts in Bunker')) {
        scrambling_attempt_rough.add(
            ((double.tryParse(value['Scrambling Success']) ?? 0.0) -
                    (double.tryParse(value['Scrambling Success in Bunker']) ??
                        0.0)) /
                ((double.tryParse(value['Scrambling Attempts']) ?? 0.0) -
                    (double.tryParse(value['Scrambling Attempts in Bunker']) ??
                        0.0)) *
                100);
      }
    });

    // Calculate averages and update the state
    setState(() {
      averageScore = scores.isNotEmpty
          ? (scores.reduce((a, b) => a + b) / scores.length).toStringAsFixed(2)
          : 'No data';
      averageDistance = drive_distances.isNotEmpty
          ? (drive_distances.reduce((a, b) => a + b) / drive_distances.length)
              .toStringAsFixed(2)
          : 'No data';
      fairwayAvg = fairway_hit.isNotEmpty
          ? (fairway_hit.reduce((a, b) => a + b) / fairway_hit.length)
              .toStringAsFixed(2)
          : 'No data';
      greenInRegAvg = green_in_regulation.isNotEmpty
          ? (green_in_regulation.reduce((a, b) => a + b) /
                  green_in_regulation.length)
              .toStringAsFixed(2)
          : 'No data';
      greenInRegOnFairwayAvg = green_in_regulation_on.isNotEmpty
          ? (green_in_regulation_on.reduce((a, b) => a + b) /
                  green_in_regulation_on.length)
              .toStringAsFixed(2)
          : 'No data';
      greenInRegOffAvg = green_in_regulation_off.isNotEmpty
          ? (green_in_regulation_off.reduce((a, b) => a + b) /
                  green_in_regulation_off.length)
              .toStringAsFixed(2)
          : 'No data';
      birdieConversionAvg = birdie_conversion.isNotEmpty
          ? (birdie_conversion.reduce((a, b) => a + b) /
                  birdie_conversion.length)
              .toStringAsFixed(2)
          : 'No data';
      puttsHoleAvg = putts_hole.isNotEmpty
          ? (putts_hole.reduce((a, b) => a + b) / putts_hole.length)
              .toStringAsFixed(2)
          : 'No data';
      puttsAvg = number_of_putts.isNotEmpty
          ? (number_of_putts.reduce((a, b) => a + b) / number_of_putts.length)
              .toStringAsFixed(2)
          : 'No data';
      threePuttsAvg = number_of_3putts.isNotEmpty
          ? (number_of_3putts.reduce((a, b) => a + b) / number_of_3putts.length)
              .toStringAsFixed(2)
          : 'No data';
      scramblingAttemptAvg = scrambling_attempt.isNotEmpty
          ? (scrambling_attempt.reduce((a, b) => a + b) /
                  scrambling_attempt.length)
              .toStringAsFixed(2)
          : 'No data';
      scramblingAttemptBunkerAvg = scrambling_attempt_bunker.isNotEmpty
          ? (scrambling_attempt_bunker.reduce((a, b) => a + b) /
                  scrambling_attempt_bunker.length)
              .toStringAsFixed(2)
          : 'No data';
      scramblingAttemptRoughAvg = scrambling_attempt_rough.isNotEmpty
          ? (scrambling_attempt_rough.reduce((a, b) => a + b) /
                  scrambling_attempt_rough.length)
              .toStringAsFixed(2)
          : 'No data';
    });
  }

  void _editLog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Map<String, dynamic> log = logs[index];
        // print(log);
        TextEditingController dateController =
            TextEditingController(text: log['logDate'].substring(0, 16));
        // TextEditingController scoreController = TextEditingController(text: log['Score'].toString());
        // TextEditingController distanceController = TextEditingController(text: log['Drive Distance'].toString());
        // TextEditingController fairwayController = TextEditingController(text: log['Fairway Hit'].toString());
        // TextEditingController greenController = TextEditingController(text: log['Green in regulation'].toString());
        // TextEditingController puttsController = TextEditingController(text: log['# of Putts'].toString());
        // TextEditingController birdiesController = TextEditingController(text: log['# of Birdies'].toString());
        // Add more controllers for other fields as needed
        // create a controller for each field using a for loop
        List<TextEditingController> controllers = [];
        for (var field in log.keys) {
          if (field != 'logDate') {
            controllers.add(TextEditingController(text: log[field].toString()));
          }
        }

        return AlertDialog(
          title: Text('Edit Log'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Date'),
                ),
                for (var i = 0; i < controllers.length; i++)
                  TextField(
                    controller: controllers[i],
                    decoration:
                        InputDecoration(labelText: log.keys.elementAt(i)),
                  ),
                // Add more fields as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  logs[index] = {
                    'logDate': dateController.text,
                    for (var i = 0; i < controllers.length; i++)
                      if (log.keys.elementAt(i) != 'logDate')
                        log.keys.elementAt(i): controllers[i].text,
                  };
                });
                print(logs[index]);
                // _saveLogs();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Golf Data and Averages'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: isLoading ? null : _predict,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Predict'),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: calculateAverages,
                    child: Text('Calculate Averages'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(result, style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Text('Average Score: $averageScore',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Drive Distance: $averageDistance',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Fairway Hit: $fairwayAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Green in Regulation: $greenInRegAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text(
                  'Average Green in Regulation on Fairway: $greenInRegOnFairwayAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Green in Regulation Off Fairway: $greenInRegOffAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Birdie Conversion Rate: $birdieConversionAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Putts per Hole: $puttsHoleAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Number of Putts: $puttsAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Number of 3 Putts: $threePuttsAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Scrambling Attempt: $scramblingAttemptAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text(
                  'Average Scrambling Attempt in Bunker: $scramblingAttemptBunkerAvg',
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),
              Text('Average Scrambling from Rough: $scramblingAttemptRoughAvg',
                  style: TextStyle(fontSize: 15)),
              const SizedBox(height: 20),
              logs.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                                'Date: ${logs[index]["logDate"].substring(0, 16)}'),
                            subtitle: Row(children: [
                              Text(
                                '${logs[index]["Scrambling Attempts"]}',
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              Text(
                                ' ${logs[index]["Scrambling Success"]}',
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              Text(
                                ' ${logs[index]["Scrambling Attempts in Bunker"]}',
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              Text(
                                ' ${logs[index]["Scrambling Success in Bunker"]}',
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editLog(index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await _deleteLog(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    )
                  : Center(
                      child: Text(
                        'No log entries available.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
