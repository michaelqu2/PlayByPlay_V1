import 'package:flutter/material.dart';
import 'route.dart';
import 'profile/profile.dart';
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
        title: const Text('Setting'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sports_background24.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 24, right: 20),
                    child: Card(
                      child: ListTile(
                        title: Text('Sports'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          print("sports setting");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SportsSettingPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
                    child: Card(
                      child: ListTile(
                        title: Text('Birthday'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          print("birthday setting");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BirthdaySettingPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
                    child: Card(
                      child: ListTile(
                        title: Text('Gender'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          print("gender setting");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GenderSettingPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
                  //   child: Card(
                  //     child: ListTile(
                  //       title: Text('Height'),
                  //       trailing: Icon(Icons.arrow_forward_ios),
                  //       onTap: () {
                  //         print("height setting");
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const HeightSettingPage(),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
                  //   child: Card(
                  //     child: ListTile(
                  //       title: Text('Weight'),
                  //       trailing: Icon(Icons.arrow_forward_ios),
                  //       onTap: () {
                  //         print("weight setting");
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const WeightSettingPage(),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
