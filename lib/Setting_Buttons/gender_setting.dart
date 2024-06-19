import 'package:flutter/material.dart';
import 'package:app_v1/setting.dart';

class GenderSettingPage extends StatefulWidget {
  const GenderSettingPage({super.key});

  @override
  State<GenderSettingPage> createState() => _GenderSettingPageState();
}

class _GenderSettingPageState extends State<GenderSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                alignment: Alignment.center,
              ),
              onPressed: () {
                print("save birthday setting");
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 37),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Sport",
                      hintText: "Select Sport",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    value: selected_sports.isNotEmpty ? selected_sports : null,
                    items: sports.map((String sport) {
                      return DropdownMenuItem<String>(
                        value: sport,
                        child: Text(sport),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selected_sports = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
