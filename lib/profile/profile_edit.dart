import 'package:flutter/material.dart';
import '/route.dart';
import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile_edit extends StatefulWidget {
  const profile_edit({super.key});

  @override
  State<profile_edit> createState() => _profile_editState();
}

class _profile_editState extends State<profile_edit> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  int _selectedAvatarIndex = 0;
  List<String> _avatars = [
    'assets/profile.png',
    'assets/profile1.jpg',
    'assets/profile2.jpg',
    'assets/profile3.jpg',
  ];

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString("Name") ?? '';
      _usernameController.text = prefs.getString("Username") ?? '';
      _bioController.text = prefs.getString("Bio") ?? '';
      _selectedAvatarIndex = prefs.getInt("AvatarIndex") ?? 0;
    });
  }

  Future<void> saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Name", _nameController.text);
    prefs.setString("Username", _usernameController.text);
    prefs.setString("Bio", _bioController.text);
    prefs.setInt("AvatarIndex", _selectedAvatarIndex);
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF1C2541),
        title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(_avatars[_selectedAvatarIndex]),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // Background color for the circle
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26, // Optional: Adds a shadow effect
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(6), // Adjust padding for better appearance
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFF3C75C6)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Select Avatar'),
                                  content: Container(
                                    width: double.maxFinite,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                      ),
                                      itemCount: _avatars.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedAvatarIndex = index;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: _selectedAvatarIndex == index ? Color(0xFF3C75C6) : Colors.transparent,
                                                width: 3.0,
                                              ),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage(_avatars[index]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3C75C6)),
                    ),
                  ),
                  controller: _nameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Username",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3C75C6)),
                    ),
                  ),
                  controller: _usernameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Bio",
                    hintText: "Bio",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3C75C6)),
                    ),
                  ),
                  controller: _bioController,
                ),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  print("save");
                  saveUserInfo();
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
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
      ),
    );
  }
}
