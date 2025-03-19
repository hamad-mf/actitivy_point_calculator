import 'package:actitivy_point_calculator/View/Add%20Activity%20Screen/add_activity_screen.dart';
import 'package:actitivy_point_calculator/View/Your%20Activities/your_activities_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid;
  bool isLoading = true; // Add a loading state

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
        uid = user.uid; // Set the UID
        isLoading = false; // Stop loading
      });
    } else {
      print("No user is currently signed in.");
      setState(() {
        isLoading = false; // Stop loading even if no user is found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If still loading, show a loading indicator
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue[900],
          ),
        ),
      );
    }

    // If uid is null, show a message or handle it appropriately
    if (uid == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "No user is currently signed in.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    // Create the Firestore stream only if uid is available
    final Stream<DocumentSnapshot<Map<String, dynamic>>> detailsStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[900], // Dark blue app bar
        elevation: 0,
        actions: [],
      ),
      body: Container(
        color: Colors.white, // White background
        child: Column(
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
                      SizedBox(height: 40),
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 15.0,
                        animation: true,
                        percent: totalPoints / 100,
                        center: Text(
                          "$totalPoints / 100",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        progressColor: Colors.blue[800],
                        backgroundColor: Colors.grey[300]!,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Your Points",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: Text('No data available.'));
              },
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddActivityScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue[800], // Dark blue button
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Add Activity",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YourActivitiesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white, // White button
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blue[800]!, // Dark blue border
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "View Submitted Activities",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
