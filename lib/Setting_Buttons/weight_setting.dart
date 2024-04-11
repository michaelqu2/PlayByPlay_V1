import 'package:flutter/material.dart';
import 'package:app_v1/setting.dart';

class WeightSettingPage extends StatefulWidget {
  const WeightSettingPage({super.key});
  @override
  State<WeightSettingPage> createState() => _WeightSettingPageState();
}

class _WeightSettingPageState extends State<WeightSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors. grey,
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
          ],
        ),
      ),
    );
  }
}