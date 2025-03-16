import 'package:actitivy_point_calculator/View/Profile%20Selection%20Screen/profile_sclection_screen.dart';
import 'package:actitivy_point_calculator/View/Registration%20Screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home screen"),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => ProfileSclectionScreen()),
                );
              },
              icon: Icon(Icons.abc))
        ],
      ),
    );
  }
}
