import 'package:actitivy_point_calculator/View/Add%20Activity%20Screen/add_activity_screen.dart';
import 'package:actitivy_point_calculator/View/Profile%20Selection%20Screen/profile_sclection_screen.dart';
import 'package:actitivy_point_calculator/View/Your%20Activities/your_activities_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int score = 34;

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
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              SizedBox(
                width: 120,
              ),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 10.0,
                animation: true,
                percent: score / 100, //
                center: Text("$score / 100",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[300]!,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          SizedBox(
            height: 80,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddActivityScreen(),
                  ));
            },
            child: Container(
              width: 320,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Colors.black, width: 1)),
              child: Center(
                child: Text(
                  "Add Activity",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YourActivitiesScreen(),
                  ));
            },
            child: Container(
              width: 320,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Colors.black, width: 1)),
              child: Center(
                child: Text(
                  "View Submitted Activities",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
