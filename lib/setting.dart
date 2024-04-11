import 'package:flutter/material.dart';
import '/main.dart';
import '/profile.dart';
import 'package:app_v1/Setting_Buttons/sports_setting.dart';
import 'package:app_v1/Setting_Buttons/birthday_setting.dart';
import 'package:app_v1/Setting_Buttons/gender_setting.dart';
import 'package:app_v1/Setting_Buttons/height_setting.dart';
import 'package:app_v1/Setting_Buttons/weight_setting.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 25),
                  child: const Text(
                    "My Account",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 24, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(500, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                ),
                onPressed: () {
                  print("sports setting");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SportsSettingPage()));
                },
                child: const Text(
                  "Sports                                                      >",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(500, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                ),
                onPressed: () {
                  print("birthday setting");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BirthdaySettingPage()));
                },
                child: const Text(
                  "Birthday                                                   >",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(500, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                ),
                onPressed: () {
                  print("gender setting");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GenderSettingPage()));
                },
                child: const Text(
                  "Gender                                                     >",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(500, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                ),
                onPressed: () {
                  print("height setting");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HeightSettingPage()));
                },
                child: const Text(
                  "Height                                                      >",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(500, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                onPressed: () {
                  print("weight setting");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeightSettingPage()));
                },
                child:
                const Text(
                  "Weight                                                     >",

                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
