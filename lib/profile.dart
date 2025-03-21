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
  bool isScrolled = false;
  ScrollController _scrollController = ScrollController();

  Color color = Colors.white;
  Color color1 = Color(0xFF0B132B);
  Color color2 = Color(0xFF1C2541);
  Color color3 = Color(0xFF3C75C6);
  Color color4 = Color(0xFF9ED6FF);
  Color color5 = Color(0xFF56F4DC);
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


  Color _appBarColor = Colors.transparent;

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
    String selectedSport = sportsTC![index];

    if (selectedSport == 'Golf') {
      return golfDrills;
    } else if (selectedSport == 'Run') {
      return runDrills;
    } else if (selectedSport == 'Swimming') {
      return swimmingDrills;
    } else {
      return [];
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
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !isScrolled) {
        setState(() {
          isScrolled = true;
          _appBarColor = color1;// Show text when scrolled
        });
      } else if (_scrollController.offset <= 100 && isScrolled) {
        setState(() {
          isScrolled = false;
          _appBarColor = Colors.transparent;// Hide text when scrolled back up
        });
      }
    });
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
  void dispose() {
    _scrollController.dispose(); // Clean up the controller
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 260.0,
            // Adjust the expanded height of the app bar
            floating: false,
            pinned: false,
            backgroundColor: _appBarColor,
            flexibleSpace: FlexibleSpaceBar(
              title: isScrolled
                  ? Text(
                "Profile Page",
                style: TextStyle(color: Colors.white),
              )
                  : null,
              background: Container(
                decoration: BoxDecoration(
                  color: color2, // AppBar color
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45.0),
                    bottomRight: Radius.circular(45.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/sports_background11.jpg"), // Your image path
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.18), // Adjust the opacity here
                      BlendMode.darken, // Mode to blend the image and color
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    // Custom container with profile image and name
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 30),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: color3,
                                  width: 0,
                                ),
                                image: DecorationImage(
                                    image: AssetImage("assets/profile.png"), // Your image path
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.0), // Adjust the opacity here
                                      BlendMode.darken, // Mode to blend the image and color
                                    ),
                                    alignment: Alignment(0.0, 0),
                                    scale: 1.5,
                                  ),
                              ),
                            ),
                          ),
                          Container(
                              width: 250.0,
                              height: 380.0,
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 30),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            // Scales the text down if it's too large
                                            child: Text(
                                              'Michael',
                                              style: TextStyle(
                                                fontSize: 24,
                                                // Initial font size
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 22, bottom: 25),
                                        child: Text(
                                          _bio, // Profile bio
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 250,
                                        padding: const EdgeInsets.only(
                                            bottom: 0, left: 14, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Share button
                                            // Edit button
                                            Container(
                                              width: 112,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: color3,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(15),

                                              ),

                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(),
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  shadowColor: color,
                                                  minimumSize: Size(120, 32),
                                                  backgroundColor: color,
                                                  elevation: 0,
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Edit Profile",
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 112,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: color3,
                                                    width: 2),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(),
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  shadowColor: color,
                                                  minimumSize: Size(120, 32),
                                                  backgroundColor: color,
                                                  elevation: 0,
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Edit Profile",
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),

                    // Settings icon on the top right

                    Container(
                      padding: const EdgeInsets.only(right: 20, top: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingPage()),
                              );
                            },
                            child:
                                const Icon(Icons.settings, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: sportsTC?.map((sport) {
                                int index = sportsTC!.indexOf(sport);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSportIndex =
                                          selectedSportIndex == index
                                              ? null
                                              : null;
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
                                            ? color4
                                            : color,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: selectedSportIndex == index
                                              ? color3
                                              : color3,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          sport,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: selectedSportIndex == index
                                                ? Colors.black
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                      SizedBox(height: 20),
                      selectedSportIndex != null
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                                      color4,
                                      color4,
                                      color4
                                    ];

                                    // Get the color based on index
                                    Color containerColor =
                                        drillColors[index % drillColors.length];

                                    return Container(
                                      height: 180,
                                      width: 165,
                                      margin: EdgeInsets.only(right: 8.0),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: containerColor,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        drill,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
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
                SizedBox(height: 15),
                // Padding(
                //   padding: const EdgeInsets.only(right: 15, left: 15),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(25),
                //     ),
                //     child: Column(
                //       children: [
                //         ListTile(
                //           leading:
                //               Icon(Icons.fitness_center, color: Colors.black),
                //           title: Text(
                //             'Physical activity',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //           subtitle: Text('2 days ago'),
                //           trailing: Icon(Icons.chevron_right),
                //           onTap: () {
                //             // Action for button
                //           },
                //         ),
                //         Divider(),
                //         ListTile(
                //           leading: Icon(Icons.analytics, color: Colors.black),
                //           title: Text(
                //             'Statistics',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //           subtitle: Text('This year: 109 kilometers'),
                //           trailing: Icon(Icons.chevron_right),
                //           onTap: () {
                //             // Action for button
                //           },
                //         ),
                //         Divider(),
                //         ListTile(
                //           leading: Icon(Icons.map, color: Colors.black),
                //           title: Text(
                //             'Analysis',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //           subtitle: Text('7'),
                //           trailing: Icon(Icons.chevron_right),
                //           onTap: () {
                //             // Action for button
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),


                SizedBox(height: 200)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
