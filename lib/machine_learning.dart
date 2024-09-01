// import 'package:flutter/material.dart';
// import '/profile.dart';
// import '/initial_questions_golf.dart';
// import '/selection.dart';
// import 'recommend_choice.dart';
// import 'golf_tips.dart';
// import 'home.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class MachineLearningPage extends StatefulWidget {
//   const MachineLearningPage({super.key});
//
//   @override
//   State<MachineLearningPage> createState() => _MachineLearningPageState();
// }
//
// class _MachineLearningPageState extends State<MachineLearningPage> {
//   final TextEditingController _controller1 = TextEditingController();
//   final TextEditingController _controller2 = TextEditingController();
//   final TextEditingController _controller3 = TextEditingController();
//   final TextEditingController _controller4 = TextEditingController();
//
//   String result = '';
//
//   Future<void> _predict() async {
//     final double? input1 = double.tryParse(_controller1.text);
//     final double? input2 = double.tryParse(_controller1.text);
//     final double? input3 = double.tryParse(_controller1.text);
//     final double? input4 = double.tryParse(_controller1.text);
//     if (input1 == null || input2 == null || input3 == null ||
//         input4 == null ||) {
//       setState(() {
//         _result = "Please enter a valid number";
//       });
//       return;
//     }
//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:5000/predict'),
//       header: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'input': [input1, input2, input3, input4],
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//       setState(() {
//         _result = 'Prediction: ${data['prediction']}';
//       });
//     }
//     else {
//       setState(() {
//         _result = "Error: ${response.reasonPhrase}";
//       });
//     }
//   }
// }
//
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(
//         'Machine Learning Model Prediction',
//         style: TextStyle(
//           fontSize: 12,
//         ),
//       ),
//     ),
//     body: SingleChildScrollView(
//       child: Column(
//         children: [
//           TextField(
//             controller: _controller1,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: 'Input 1'),
//           ),
//           TextField(
//             controller: _controller1,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: 'Input 1'),
//           ),
//           TextField(
//             controller: _controller1,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: 'Input 1'),
//           ),
//           TextField(
//             controller: _controller1,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: 'Input 1'),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(onPressed: _predict, child: Text('Predict')),
//           SizedBox(height: 20),
//           Text(_result, style: TextStyle(fontSize: 20))
//
//
//         ],
//       ),
//     ),
//   );
// }