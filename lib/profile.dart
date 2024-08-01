import 'package:flutter/material.dart';
import '/route.dart';
import '/profile_edit.dart';
import '/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "";
  String _bio = "";
  String _username = "";
  late SharedPreferences prefs;

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString("Name") ?? '');
      _bio = (prefs.getString("Bio") ?? '');
      _username = (prefs.getString("Username") ?? '');

    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadInfo();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors. white,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingPage()));
                  },
                  child: const Icon(Icons.settings),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                width: 375.0,
                height: 200.0,
                alignment: Alignment.topLeft,
                child: (Row(children: [
                  Container(
                      width: 175.0,
                      height: 200.0,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Text(
                            "    ",
                            style: TextStyle(
                              fontSize: 5,
                            ),
                          ),
                          Container(
                            width: 130,
                            height: 130,
                            color: Colors.cyanAccent,
                          ),
                          const Text(
                            "    ",
                            style: TextStyle(
                              fontSize: 15.5,
                            ),
                          ),
                          Text(_name,
                              style: const TextStyle(
                                fontSize: 12,
                              ))
                        ],
                      )),
                  Container(
                      width: 200.0,
                      height: 200.0,
                      color: Colors.white,
                      child: (Column(children: [
                        Container(
                            width: 225.0,
                            height: 150.0,
                            color: Colors.white,
                            alignment: Alignment.bottomCenter,
                            child: Column(children: [
                              Text(
                                "     ",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                _username,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                _bio,
                                style: TextStyle(
                                  fontSize: 10,
                                )
                              ),
                            ])),
                        Container(
                            width: 225.0,
                            height: 50.0,
                            color: Colors.white,
                            child: Row(children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black
                                ),
                                onPressed: () {
                                  print("edit profile");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const profile_edit()));
                                },
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                    foregroundColor: Colors.black
                                ),
                                onPressed: () {
                                  print("share_profile");
                                },
                                child: const Text("Share Profile",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ])),
                      ])))
                ]))),
            Container(
                width: 375,
                height: 185,
                color: Colors.cyanAccent,
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Graph"),
                    ])),
            Container(
                width: 375,
                height: 300,
                color: Colors.white,
                child: Column(
                  children: [
                    const Text(
                      "  ",
                      style: TextStyle(
                        fontSize: 5,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                          foregroundColor: Colors.black
                      ),
                      onPressed: () {
                        print("statistics1");
                      },
                      child: const Text(
                        "Statistics",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(
                      "  ",
                      style: TextStyle(
                        fontSize: 5,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                          foregroundColor: Colors.black
                      ),
                      onPressed: () {
                        print("activities");
                      },
                      child: const Text(
                        "Activities",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(
                      "  ",
                      style: TextStyle(
                        fontSize: 5,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                          foregroundColor: Colors.black
                      ),
                      onPressed: () {
                        print("progress");
                      },
                      child: const Text(
                        "Progress",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ))
          ]),
        ));
  }
}
