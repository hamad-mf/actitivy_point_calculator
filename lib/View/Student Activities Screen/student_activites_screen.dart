import 'dart:developer';

import 'package:actitivy_point_calculator/View/Manage%20Activity/manage_activity_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentActivitesScreen extends StatelessWidget {
  final String registerno;
  const StudentActivitesScreen({super.key, required this.registerno});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('uploads')
            .where('register_no', isEqualTo: registerno)
            .snapshots(),
        builder: (context, snapshot) {
          // Add detailed error handling
          if (snapshot.hasError) {
            print("Firestore error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
                child: Text('No activities found for this user.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              try {
                final activityData = docs[index].data() as Map<String, dynamic>;
                final docid = docs[index].id;
                final userid = activityData['userid'];
                final activityName = activityData['activity'] ?? 'No Activity';
                final activityDate = activityData['date'];
                final activityStatus = activityData['status'] ?? 'Pending';
                final activityreqPoints =
                    activityData['req_point'] ?? 'Pending';
                final activityCategoryName =
                    activityData['activity_category'] ?? 'Pending';
                final description = activityData['description'] ?? 'Pending';
                final image_url = activityData['image_url'] ?? 'Pending';
                final regno = activityData['register_no'] ?? 'Pending';
                final stdname = activityData['name'] ?? 'Pending';
                // Format date if possible
                String formattedDate = 'No Date';
                if (activityDate != null) {
                  try {
                    if (activityDate is Timestamp) {
                      formattedDate = DateFormat('dd/MM/yyyy')
                          .format(activityDate.toDate());
                    } else if (activityDate is String) {
                      formattedDate = activityDate;
                    }
                  } catch (e) {
                    formattedDate = 'Invalid Date';
                    print("Date format error: $e");
                  }
                }

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      log(userid.toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageActivityScreen(
                              ordereditemid: docid,
                              userid: userid,
                              activityCategoryName: activityCategoryName,
                              activityName: activityName,
                              date: formattedDate,
                              description: description,
                              img_url: image_url,
                              registerNo: regno,
                              req_points: activityreqPoints,
                              status: activityStatus,
                              studentName: stdname,
                            ),
                          ));
                    },
                    child: ListTile(
                      tileColor: Colors.grey.shade300,
                      title: Text(activityName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: $formattedDate"),
                          Text("Requested Points: $activityreqPoints"),
                          Text("Status: $activityStatus"),
                        ],
                      ),
                    ),
                  ),
                );
              } catch (e) {
                print("Error rendering activity: $e");
                log("Error rendering activity: $e");
                return const Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child:
                      ListTile(title: Text("Error displaying this activity")),
                );
              }
            },
          );
        },
      ),
    );
  }
}
