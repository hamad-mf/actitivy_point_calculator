import 'dart:developer';

import 'package:actitivy_point_calculator/Controller/upload_image_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  // Activity categories and their respective activities
  final Map<String, List<String>> activities = {
    "Technical Activities": [
      "Paper Presentations",
      "Project Competitions",
      "Hackathons",
      "Technical Workshops",
      "Technical Internships",
      "Coding Contests",
      "Patent Filing",
      "Startup or Innovation Projects"
    ],
    "Sports & Games": [
      "University/College Sports Competitions",
      "Intercollegiate Tournaments",
      "District/National Level Participation",
      "Marathons & Adventure Activities",
      "Yoga & Fitness Events"
    ],
    "Cultural Activities": [
      "Music, Dance, and Arts Competitions",
      "Drama & Theater Performances",
      "Photography & Short Film Contests",
      "Cultural Fest Participation"
    ],
    "Social & Voluntary Activities": [
      "NSS Participation",
      "Blood Donation Camps",
      "Environmental Awareness Programs",
      "Teaching Underprivileged Students",
      "Disaster Relief Volunteering"
    ],
    "Leadership & Organizational Roles": [
      "Event Coordinator",
      "Student Club Leadership",
      "Class Representative",
      "Placement Cell Volunteering",
      "Committee Member in Professional Societies"
    ],
    "Industry & Career-Oriented Activities": [
      "Internships & Training Programs",
      "Workshops on Career Development",
      "Industrial Visits",
      "Freelancing Projects",
      "Part-Time Jobs Related to the Field"
    ],
    "Online Courses & Certifications": [
      "NPTEL/SWAYAM/EdX/Udemy/Coursera Certifications",
      "MOOCs",
      "Skill Development & Training Programs"
    ],
  };

  String? selectedCategory;
  String? selectedActivity;
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? name;
  String? regno;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Header background color

            colorScheme: ColorScheme.light(primary: Colors.blue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchName(); // Fetch the user's name when the screen loads
  }

  Future<void> fetchName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc.data()!['name'];
          regno = userDoc.data()!['register_no'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadController = context.watch<UploadImageController>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                log(name.toString());
              },
              icon: Icon(Icons.ac_unit))
        ],
        title: Text("Add an activity"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Activity Type:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedCategory,
                hint: Text("Choose Category"),
                isExpanded: true,
                items: activities.keys.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    selectedActivity = null; // Reset activity selection
                  });
                },
              ),
              SizedBox(height: 20),
              if (selectedCategory != null) ...[
                Text("Select Activity:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedActivity,
                  hint: Text("Choose Activity"),
                  isExpanded: true,
                  items: activities[selectedCategory!]!.map((String activity) {
                    return DropdownMenuItem<String>(
                      value: activity,
                      child: Text(activity),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedActivity = newValue;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Description:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                        hintText: "Enter the details",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        contentPadding: EdgeInsets.all(16)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Select Date",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "DD-MM-YYYY",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.blue),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: uploadController.pickImage,
                  child: Text('Pick Image'),
                ),
                if (uploadController.selectedImage != null)
                  Image.file(uploadController.selectedImage!, height: 200),
                SizedBox(height: 16),
                uploadController.isUploading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ButtonStyle(
                            textStyle: WidgetStatePropertyAll(TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                            minimumSize: WidgetStatePropertyAll(
                                Size(double.infinity, 50)),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue)),
                        onPressed: () async {
                          await uploadController.uploadAndSaveImage(
                              status: "not verified",
                              regno: regno!,
                              name: name!,
                              activity_category: selectedCategory.toString(),
                              activity: selectedActivity.toString(),
                              date: _dateController.text.toString(),
                              description: _descriptionController.text,
                              context: context);
                          setState(() {
                            _dateController.clear();
                            _descriptionController.clear();
                            selectedActivity = null;
                            selectedCategory = null;
                            log("Cleared");
                          });
                        },
                        child: Text('SUBMIT'),
                      ),
                // SizedBox(
                //   height: 20,
                // ),
                // ElevatedButton(
                //     style: ButtonStyle(
                //         textStyle: WidgetStatePropertyAll(TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.bold)),
                //         minimumSize:
                //             WidgetStatePropertyAll(Size(double.infinity, 50)),
                //         foregroundColor: WidgetStatePropertyAll(Colors.white),
                //         backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                //     onPressed: () {},
                //     child: Text("SUBMIT"))
              ],
            ],
          ),
        ),
      ),
    );
  }
}
