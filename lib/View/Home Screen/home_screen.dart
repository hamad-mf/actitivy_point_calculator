import 'package:actitivy_point_calculator/View/Add%20Activity%20Screen/add_activity_screen.dart';
import 'package:actitivy_point_calculator/View/Profile%20Selection%20Screen/profile_sclection_screen.dart';
import 'package:actitivy_point_calculator/View/Your%20Activities/your_activities_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid;
  @override
  void initState() {
    super.initState();
    getCurrentUserUID();
  }

  void getCurrentUserUID() {
    final User? user =
        FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      setState(() {
        uid = user.uid; // Retrieve the UID
      });
    } else {
      print("No user is currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> detailsStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

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
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: detailsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data!.data() != null) {
                final data = snapshot.data!.data()!;
                final int totalPoints = data['total_points'] ?? 0;
                return Column(
                  children: [
                    // Center(
                    //   child: Text(data['total_points'] ?? ""),
                    // ),
                    SizedBox(
                      height: 80,
                    ),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 10.0,
                      animation: true,
                      percent: totalPoints / 100,
                      center: Text("$totalPoints / 100",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      progressColor: Colors.blue,
                      backgroundColor: Colors.grey[300]!,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ],
                );
              }
              return Center(child: Text('No data available.'));
            },
          ),
          SizedBox(
            height: 30,
          ),
          Row(),
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
