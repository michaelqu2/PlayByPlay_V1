import 'package:flutter/material.dart';
import 'package:app_v1/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BirthdaySettingPage extends StatefulWidget {
  const BirthdaySettingPage({super.key});

  @override
  State<BirthdaySettingPage> createState() => _BirthdaySettingPageState();
}

class _BirthdaySettingPageState extends State<BirthdaySettingPage> {
  late DateTime birthday;
  TextEditingController _birthdayController = TextEditingController();

  Future<void> DateSelect() async {

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null){
      setState(() {
        _birthdayController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _birthdayController.text = prefs.getString("Birthday") ?? '';
    });
  }

  Future<void> saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Birthday", _birthdayController.text);
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
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Birthday",
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_month),
                  hintText: "Birthday",
                ),
                readOnly: true,
                controller: _birthdayController,
                onTap:(){
                  DateSelect();
                },
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                alignment: Alignment.center,
              ),
              onPressed: () {
                print("save birthday setting");
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
      ),
    );
  }
}
