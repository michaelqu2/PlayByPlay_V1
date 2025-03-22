import 'package:app_v1/constants.dart';
import 'package:flutter/material.dart';
import 'package:app_v1/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/evaluateYourLevel/evaluateYourLevel.dart';

class SportsSettingPage extends StatefulWidget {
  const SportsSettingPage({super.key});

  @override
  State<SportsSettingPage> createState() => _SportsSettingPageState();
}

class _SportsSettingPageState extends State<SportsSettingPage> {
  bool _isSwimmingSelected = false;
  bool _isGolfSelected = false;

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sports = prefs.getStringList('sports');
    if (sports != null) {
      setState(() {
        _isSwimmingSelected = sports!.contains('Swimming');
        _isGolfSelected = sports!.contains('Golf');
      });
    }
  }

  Future<void> saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> sports = [];
    if (_isSwimmingSelected) {
      sports.add('Swimming');
    }
    if (_isGolfSelected) {
      sports.add('Golf');
    }
    prefs.setStringList('sports', sports);
  }

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: color2,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/sports_background2.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text("Swimming"),
                          value: _isSwimmingSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              _isSwimmingSelected = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Golf"),
                          value: _isGolfSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              _isGolfSelected = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  print("save sports setting");
                  saveUserInfo();
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
            ],
          ),
        ],
      ),
    );
  }
}
