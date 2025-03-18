import 'package:actitivy_point_calculator/Controller/your_activities_screen_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class YourActivitiesScreen extends StatefulWidget {
  const YourActivitiesScreen({super.key});

  @override
  State<YourActivitiesScreen> createState() => _YourActivitiesScreenState();
}

class _YourActivitiesScreenState extends State<YourActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    final activitiesController =
        Provider.of<YourActivitiesScreenController>(context);

    final userActivitiesStream = activitiesController
        .getUserActivitiesStream(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
        appBar: AppBar(
          title: Text("Your activities"),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: userActivitiesStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "no actitvies submitted",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final activitiesItem = snapshot.data!.docs[index];
                  final activityItemId = activitiesItem.id;
                  return ExpansionTile(
                      showTrailingIcon: false,
                      title: Container(
                        padding: EdgeInsets.all(12),
                        height: 190,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Category: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text(
                                        activitiesItem['activity_category'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Activity:    ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text(
                                        activitiesItem['activity'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Submitted Date:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('dd-MM-yyyy HH:mm').format(
                                          (activitiesItem['uploaded_at']
                                                  as Timestamp)
                                              .toDate(),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Status: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        activitiesItem['status'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          // Set text color based on status
                                          color: activitiesItem['status'] ==
                                                  'not verified'
                                              ? Colors
                                                  .red // Red for 'not verified'
                                              : Colors
                                                  .blue, // Green for 'verified'
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                          ],
                        ),
                      ));
                },
              );
            },
          ),
        ));
  }
}
