import 'package:flutter/material.dart';
import 'package:app_v1/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void AddSportField(){
    setState(() {
      sportsTC.add(TextEditingController());
    });
  }
  void RemoveSportField(int index){
    setState(() {
      if(sportsTC.length>1){
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 800,
                height: 100,
                child: Center(
                  child: DropdownButton(
                    value: sports_choice,
                    items: s_choices.map((String item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        sports_choice = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 800,
                height: 100,
                child: Center(
                  child: DropdownMenu<String>(
                    width: 300,
                    initialSelection: sports_choice,
                    onSelected: (String? value) {
                      setState(() {
                        sports_choice = value!;
                      });
                    },
                    dropdownMenuEntries: s_choices
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
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
