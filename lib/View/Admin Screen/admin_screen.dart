import 'package:actitivy_point_calculator/View/Profile%20Selection%20Screen/profile_sclection_screen.dart';
import 'package:actitivy_point_calculator/View/Student%20Activities%20Screen/student_activites_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'user')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[900], // Dark blue app bar
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isAdminLoggedIn', false);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ProfileSclectionScreen()),
              );
            },
            icon: Icon(
              Icons.exit_to_app_outlined,
              color: Colors.white, // White icon
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[900], // Dark blue loading indicator
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No users found.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          // Extract user data from the snapshot
          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final userData = userDocs[index].data() as Map<String, dynamic>;
              final userName = userData['name'] ?? 'No Name'; // Get the name
              final registerno = userData['register_no'] ??
                  'No Registerno'; // Get the registerno

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentActivitesScreen(registerno: registerno),
                      ),
                    );
                  },
                  title: Text(
                    userName,
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Registerno: $registerno",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue[900], // Dark blue icon
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
