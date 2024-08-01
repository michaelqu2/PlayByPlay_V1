import 'package:flutter/material.dart';
import 'package:app_v1/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_v1/selection.dart';
class SportsSettingPage extends StatefulWidget {
  const SportsSettingPage({super.key});

  @override
  State<SportsSettingPage> createState() => _SportsSettingPageState();
}

class _SportsSettingPageState extends State<SportsSettingPage> {
  List<TextEditingController> sportsTC = [TextEditingController()];

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sportsTC = (prefs.getStringList('sports') ?? []).map((sport) {
        return TextEditingController(text: sport);
      }).toList();
    });
  }

  Future<void> saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'sports',
      sportsTC
          .map((controller) => controller.text.trim())
          .where((sport) => sport.isNotEmpty)
          .toList(),
    );
  }

  void AddSportField() {
    setState(() {
      sportsTC.add(TextEditingController());
    });
  }

  void RemoveSportField(int index) {
    setState(() {
      if (sportsTC.length > 1) {
        sportsTC.removeAt(index);
      }
    });
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(children: [
                  const Text("Sport"),
                  for (int i = 0; i < sportsTC.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  counterText: ' ',
                                  hintText: "Sport ${i + 1}",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              controller: sportsTC[i],
                            ),
                          ),

                          IconButton(
                              onPressed: () => RemoveSportField(i),
                              icon: const Icon(Icons.delete)),

                        ],
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                        onPressed: AddSportField,
                        icon: const Icon(Icons.add)),
                  )
                ]),
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
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));

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
    );
  }
}
