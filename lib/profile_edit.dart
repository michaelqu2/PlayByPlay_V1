import 'package:flutter/material.dart';
import '/main.dart';
import '/profile.dart';
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

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString("Name") ?? '';
      _usernameController.text = prefs.getString("Username") ?? '';
      _bioController.text = prefs.getString("Bio") ?? '';
    });
  }

  Future<void> saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Name", _nameController.text);
    prefs.setString("Username", _usernameController.text);
    prefs.setString("Bio", _bioController.text);
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
        backgroundColor: Colors. grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
                ),
                controller: _nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Username",
                ),
                controller: _usernameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Bio",
                  hintText: "Bio",
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
    );
  }
}
