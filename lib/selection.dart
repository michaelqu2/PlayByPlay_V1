import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import 'package:app_v1/home.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  List<String> sportsTC = [];

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sportsTC = (prefs.getStringList('sports') ?? []).map((sport)).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Selection Page"),
            DropdownButton(items: sportsTC, onChanged: (String newvalue{

            }), value: chosen_sport,)
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InitialQuestionsGolfPage()));
              },
              child: const Text(
                "Initial Golf Questions",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

