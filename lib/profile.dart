import 'package:flutter/material.dart';
import '/route.dart';
import '/profile_edit.dart';
import '/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String>? sportsTC = [];
  String _name = "";
  String _bio = "";
  String _username = "";

  File? _image;
  late SharedPreferences prefs;

  int? selectedSportIndex;

  List<String> golfDrills = [
    'Sprint',
    'Long run',
    'Interval training',
  ];

  List<String> swimmingDrills = [
    'Uphill climb',
    'Speed hiking',
    'Trail navigation',
  ];

  List<String> runDrills = [
    'Sun salutation',
    'Warrior poses',
    'Balance practice',
  ];

  List<String> _getDrillsForSport(int index) {
    String selectedSport = sportsTC![index]; // Get the sport name by index

    if (selectedSport == 'Golf') {
      return golfDrills;
    } else if (selectedSport == 'Run') {
      return runDrills;
    } else if (selectedSport == 'Swimming') {
      return swimmingDrills;
    } else {
      return []; // Return an empty list if no drills are found
    }
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sportsTC = prefs.getStringList('sports');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
    loadUserInfo();
  }

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString("Name") ?? '');
      _bio = (prefs.getString("Bio") ?? '');
      _username = (prefs.getString("Username") ?? '');
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.937,
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 220.0,
                    height: 200.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, bottom: 15),
                          child: Text(
                            _name,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 19, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 115,
                                    height: 45,
                                    margin: EdgeInsets.only(right: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.left,
                                      _bio,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    margin: EdgeInsets.only(right: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const profile_edit(),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.share),
                                      iconSize: 15,
                                    ),
                                  ),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.red, width: 0),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const profile_edit(),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                      iconSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: Container(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sportsTC?.map((sport) {
                              int index = sportsTC!
                                  .indexOf(sport); // Null check handled with !
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSportIndex =
                                        selectedSportIndex == index
                                            ? null
                                            : index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: selectedSportIndex == index
                                          ? Colors.white
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: selectedSportIndex == index
                                            ? Color.fromRGBO(255, 170, 128, 1)
                                            : Colors.black38,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          sport,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: selectedSportIndex == index
                                                ? Colors.black
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList() ??
                            [], // Handle null case with an empty list
                      ),
                    ),
                    SizedBox(height: 20),
                    selectedSportIndex != null
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children:
                                    _getDrillsForSport(selectedSportIndex!)
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                  int index = entry.key;
                                  String drill = entry.value;

                                  // List of colors for the drills
                                  List<Color> drillColors = [
                                    Color.fromRGBO(128, 223, 255, 1),
                                    Color.fromRGBO(180, 255, 180, 1),
                                    Color.fromRGBO(255, 191, 128, 1)
                                  ];

                                  // Get the color based on index, using modulo for looping over the color list
                                  Color containerColor =
                                      drillColors[index % drillColors.length];

                                  return Container(
                                    height: 180,
                                    width: 165,
                                    margin: EdgeInsets.only(right: 8.0),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          containerColor, // Set container color
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      drill,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(

                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15), // Padding around the container
              child: Container(
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(255, 230, 205, 1),
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2), // Shadow color
                  //     spreadRadius: 2,
                  //     blurRadius: 8,
                  //     offset: Offset(0, 3), // Shadow position
                  //   ),
                  // ],
                ),
                child: Column(
                  children: [
                    // Button 1 - Physical activity
                    ListTile(
                      leading: Icon(Icons.fitness_center, color: Colors.black),
                      title: Text(
                        'Physical activity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('2 days ago'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // Action for button 1
                      },
                    ),
                    Divider(), // Separator line

                    // Button 2 - Statistics
                    ListTile(
                      leading: Icon(Icons.analytics, color: Colors.black),
                      title: Text(
                        'Statistics',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('This year: 109 kilometers'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // Action for button 2
                      },
                    ),
                    Divider(), // Separator line

                    // Button 3 - Routes
                    ListTile(
                      leading: Icon(Icons.map, color: Colors.black),
                      title: Text(
                        'Analysis',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('7'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // Action for button 3
                      },
                    ),
                    Divider(), // Separator line

                    // Button 4 - Best time
                    ListTile(
                      leading: Icon(Icons.timer, color: Colors.black),
                      title: Text(
                        'Progress',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Show all'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // Action for button 4
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 200)
          ],
        ),
      ),
    );
  }
}
