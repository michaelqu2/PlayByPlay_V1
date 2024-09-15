import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/selection.dart';
import 'recommend_choice.dart';
import 'golf_tips.dart';
import 'machine_learning.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0; // Initially selected date is today
  List<Map<String, dynamic>> days = [];

  Color color = Colors.white;
  Color color1 = Color(0xFF0B132B);
  Color color2 = Color(0xFF1C2541);
  Color color3 = Color(0xFF3a506b);
  Color color4 = Color(0xFF9BE4E3);
  Color color5 = Color(0xFF56F4DC);
  Color color6 = Color(0xFF72f6fb);

  List<Color> colors = [
    Color(0xFF9BE4E3),
    Color(0xFF72f6fb),
    Color(0xFF56F4DC),

  ];

  List<Color> colors2 = [
    Colors.black54,
    Colors.black54,
    Colors.black54,
  ];

  List<String>? sportsTC = [];

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sportsTC = prefs.getStringList('sports');
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    generateDates();
  }

  void generateDates() {
    DateTime now = DateTime(2024,5,3,0,0); // Get the current date
    DateTime monday = now.subtract(Duration(days: now.weekday - 1)); // Calculate Monday of the current week

    for (int i = 0; i < 7; i++) {
      DateTime currentDate = monday.add(Duration(days: i));
      String dayName = DateFormat('E').format(currentDate); // Get the day name (e.g., Mon)
      String dayNumber = DateFormat('d').format(currentDate); // Get the day number (e.g., 23)
      bool isToday = currentDate.day == now.day &&
          currentDate.month == now.month &&
          currentDate.year == now.year;
      days.add({
        'day': dayName,
        'date': dayNumber,
        'isToday': isToday,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
              child: Column(
                children: [
                  Container(
                    height: 170,
                    width: 345,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: color,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5), // Shadow color
                      //     spreadRadius: 5, // How much the shadow spreads
                      //     blurRadius: 7, // How blurry the shadow is
                      //     offset: Offset(0, 3), // Position of the shadow (x, y)
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 20),
                          child: Column(
                            children: [
                              Text(
                                "Day 7",
                                style: TextStyle(
                                  fontSize: 26,
                                ),
                              ),

                            ],
                          )
                        ),

                      ],
                    ),
                    // child: SizedBox(
                    //   child: ListView(
                    //     children: [
                    //       // TipsPage(),
                    //     ],
                    //   ),
                    // ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Container(
              height: 70,

              padding: EdgeInsets.only(left: 25, right: 27),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  bool isToday = days[index]['isToday'];
                  return GestureDetector(
                    onTap: isToday
                        ? () {
                      setState(() {
                        selectedIndex = index; // Update selected date only if it is today
                      });
                    }
                        : null, // Disable onTap for other days
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 0), // Spacing
                          Container(
                            width: 44.5,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isToday ? color3 : Colors.white, // Only today is black
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isToday ? color3 : color3,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  days[index]['day'],
                                  style: TextStyle(
                                    color: isToday ? color : Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  days[index]['date'],
                                  style: TextStyle(
                                    color: isToday ? color : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
            // Container(
            //   margin: EdgeInsets.only(left: 20),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //       "Prediction",
            //       style: TextStyle(
            //         fontSize: 24,
            //       ),
            //   ),
            // ),
            SizedBox(height: 15,),
            Container(
              width: 375.0,
              height: 400.0,
              decoration: BoxDecoration(

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage("assets/sports_background4.jpg"), // Replace with your image path
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.38), // Adjust the opacity here
                                BlendMode.darken, // Mode to blend the image and color
                              ),// This adjusts how the image fits the container
                            ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.3), // Shadow color
                            //     spreadRadius: 5, // How much the shadow spreads
                            //     blurRadius: 5, // How blurry the shadow is
                            //     offset: Offset(0, 3), // Position of the shadow (x, y)
                            //   ),
                            // ],
                          ),
                          height: 240,
                          width: 170,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 4, top: 0, bottom: 12, right: 0),
                                child: Text(
                                  'Evaluation',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int index = 0;
                                    index < sportsTC!.length;
                                    index++) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                sportsTC![index],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: color,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 0),
                                              height: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: colors[index],
                                                ),
                                                color: Colors.black.withOpacity(0.5),
                                                borderRadius:
                                                BorderRadius.circular(4),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'can\'t tell',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                        color: Colors.grey[300],
                                        height: 0,
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectionPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  shadowColor: color,

                                  minimumSize: Size(150, 32),
                                  backgroundColor: color,
                                  elevation: 0,
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Evaluate Your Level",
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 15, right: 10),
                            height: 240,
                            width: 170,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage("assets/sports_background1.jpg"), // Replace with your image path
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.38), // Adjust the opacity here
                                  BlendMode.darken, // Mode to blend the image and color
                                ),// This adjusts how the image fits the container
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color
                                  spreadRadius: 5, // How much the shadow spreads
                                  blurRadius: 7, // How blurry the shadow is
                                  offset: Offset(0, 3), // Position of the shadow (x, y)
                                ),
                              ],
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                         top:15, left: 15, right: 15),
                                    child: Text(
                                      'Find Your Sports',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                         left: 10, right: 10, bottom: 10),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecommendChoicePagePage(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: Size(140, 35),
                                        backgroundColor: color,
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Get Recommendations",
                                        style: TextStyle(
                                          fontSize: 8.40,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ])),
                        Container(
                          decoration: BoxDecoration(
                          ),
                          padding: EdgeInsets.only(bottom: 10, right: 10),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MachineLearningPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(140, 55),
                              maximumSize: Size(140, 75),
                              backgroundColor: color,
                              shadowColor: color1,
                              // elevation: 2,
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              textAlign: TextAlign.right,
                              "Prediction",
                              style: TextStyle(
                                fontSize: 16,
                                color: color2,
                              ),
                            ),
                          ),
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
    );
  }
}