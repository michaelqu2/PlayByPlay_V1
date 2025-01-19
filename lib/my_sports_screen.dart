import 'dart:convert';
import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/route.dart';
import 'package:app_v1/logging_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'logging_display.dart';
import 'logging_record_backup.dart';
import 'logging_record.dart';
import 'sport_logs.dart';
import 'golf_data_backend.dart';

class MySportsScreenPage extends StatefulWidget {
  const MySportsScreenPage({super.key});

  @override
  State<MySportsScreenPage> createState() => _MySportsScreenPageState();
}

class _MySportsScreenPageState extends State<MySportsScreenPage> {
  List<String> sports = [];
  late String selectedSports = sports.isNotEmpty ? sports.first : '';
  double progressValue = 0.3; // Example value (30% progress)

  Color color = Colors.white;
  Color color1 = Color(0xFF0B132B);
  Color color2 = Color(0xFF1C2541);
  Color color3 = Color(0xFF3C75C6);
  Color color4 = Color(0xFF9ED6FF);
  Color color5 = Color(0xFF50CEFF);
  Color color6 = Color(0xFF72f6fb);
  Color color7 = Color(0xFF060A18);
  Color color8 = Color(0xFF3a506b);
  Color color9 = Color(0xFFC91818);
  Color color10 = Color(0xFFFF4D4F);
  Color color11 = Color(0xFFFF7275);
  Color color12 = Color(0xFFFFC4AB);
  Color color13 = Color(0xFFFF8C8C);
  Color color14 = Color(0xFFa31414);
  Color color15 = Color(0xFF9BE4E3);

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('sports')) sports = prefs.getStringList('sports')!;
      sports.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      selectedSports = prefs.getString('selected_sport') ??
          (sports.isNotEmpty ? sports.first : '');
    });
  }

  Future<void> saveUserSports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_sport', selectedSports);
  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
                child: SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: screenHeight * 0.18,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 10, top: 0, bottom: 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                          width: screenWidth * 0.48,
                                          height: screenHeight * 0.166,
                                          decoration: BoxDecoration(
                                            color: color2,
                                            borderRadius:
                                                BorderRadius.circular(30),


                                          ),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 35.0,
                                                          left: 0,
                                                          right: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "57",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 7),
                                                      // Countdown Timer
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Logs Recorded",
                                                            style: TextStyle(
                                                              color: color,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                            width: screenWidth * 0.42,
                                            height: screenHeight * 0.18,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: screenWidth * 0.37,
                                                    height:
                                                        screenHeight * 0.094,
                                                    decoration: BoxDecoration(
                                                      color: color8,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                    ),
                                                    child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0,
                                                                    left: 4),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Goal Progress",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 7),
                                                                // Countdown Timer
                                                                Container(
                                                                  width:
                                                                      screenWidth *
                                                                          0.3,
                                                                  // Set a specific width constraint
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        // Allows the LinearProgressIndicator to take up available space
                                                                        child:
                                                                            LinearProgressIndicator(
                                                                          value:
                                                                              progressValue,
                                                                          // Progress value between 0.0 and 1.0
                                                                          backgroundColor:
                                                                              color,
                                                                          color:
                                                                              color4,
                                                                          minHeight:
                                                                              7,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              10),
                                                                      Text(
                                                                        (progressValue * 100).toString() +
                                                                            "%",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                color,
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                      )
                                                                      // Add spacing between the progress bar and button
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      print("add log");
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoggingRecordPage()));
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size(
                                                        screenWidth * 0.37,
                                                        screenHeight * 0.06,
                                                      ),
                                                      backgroundColor: color4,
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Add Log",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                      )
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 30, left: 30,bottom: 0),
                                child: Text("Log Recorded",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),

                                ),
                              ),
                              Container(
                                  child: Flexible(
                                    child: Scrollbar(
                                      child: ListView.builder(
                                        itemCount: sports.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                  Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // Position of the shadow (x, y)
                                                ),
                                              ],
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/sports_background21.jpg"),
                                                // Replace with your image path
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.0),
                                                  // Adjust the opacity here
                                                  BlendMode
                                                      .darken, // Mode to blend the image and color
                                                ), // This adjusts how the image fits the container
                                              ),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 8),
                                            // Adjust margin around the Card
                                            child: ListTile(
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 20),
                                              // Adjusts padding inside the ListTile
                                              // leading: Text('data'),
                                              title: Text(
                                                '${sports[index]}',
                                                style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                  18, // Change font size for the text
                                                ),
                                              ),
                                              // subtitle: Text('data'),
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.arrow_circle_right_outlined,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  selectedSports = sports[index];
                                                  saveUserSports();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          GolfDataBackendPage(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                              )

                            ]))))));
  }
}
