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
    "Others": ["Others"],
  };

  final Map<String, int> pointsMap = {
    "Paper Presentations": 10,
    "Project Competitions": 15,
    "Hackathons": 20,
    "Technical Workshops": 10,
    "Technical Internships": 15,
    "Coding Contests": 12,
    "Patent Filing": 25,
    "Startup or Innovation Projects": 30,
    "University/College Sports Competitions": 10,
    "Intercollegiate Tournaments": 12,
    "District/National Level Participation": 15,
    "Marathons & Adventure Activities": 10,
    "Yoga & Fitness Events": 8,
    "Music, Dance, and Arts Competitions": 10,
    "Drama & Theater Performances": 12,
    "Photography & Short Film Contests": 10,
    "Cultural Fest Participation": 8,
    "NSS Participation": 10,
    "Blood Donation Camps": 8,
    "Environmental Awareness Programs": 10,
    "Teaching Underprivileged Students": 12,
    "Disaster Relief Volunteering": 15,
    "Event Coordinator": 10,
    "Student Club Leadership": 15,
    "Class Representative": 12,
    "Placement Cell Volunteering": 10,
    "Committee Member in Professional Societies": 12,
    "Internships & Training Programs": 15,
    "Workshops on Career Development": 10,
    "Industrial Visits": 8,
    "Freelancing Projects": 15,
    "Part-Time Jobs Related to the Field": 12,
    "NPTEL/SWAYAM/EdX/Udemy/Coursera Certifications": 10,
    "MOOCs": 8,
    "Skill Development & Training Programs": 10,
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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Add an Activity",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[900], // Dark blue app bar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select Activity Type
              InkWell(
                onTap: () {
                  log(FirebaseAuth.instance.currentUser!.uid);
                },
                child: Text(
                  "Select Activity Type:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: Text(
                  "Choose Category",
                  style: TextStyle(color: Colors.blue[900]),
                ),
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue[900]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
                  ),
                ),
                items: activities.keys.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.blue[900]),
                    ),
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
              // Select Activity
              if (selectedCategory != null) ...[
                Text(
                  "Select Activity:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedActivity,
                  hint: Text(
                    "Choose Activity",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue[900]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.blue[900]!, width: 2),
                    ),
                  ),
                  items: activities[selectedCategory!]!.map((String activity) {
                    return DropdownMenuItem<String>(
                      value: activity,
                      child: Text(
                        activity,
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedActivity = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Description
                Text(
                  "Description:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 150,
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: "Enter the details",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue[900]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.blue[900]!, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Select Date
                Text(
                  "Select Date:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "DD-MM-YYYY",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue[900]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.blue[900]!, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.blue[900]),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Pick Image Button
                ElevatedButton(
                  onPressed: uploadController.pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800], // Dark blue button
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Pick Image',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Display Selected Image
                if (uploadController.selectedImage != null)
                  Image.file(uploadController.selectedImage!, height: 200),
                SizedBox(height: 20),
                // Submit Button
                uploadController.isUploading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          num points = pointsMap[selectedActivity] ?? 0;
                          await uploadController.uploadAndSaveImage(
                            comments: "",
                            userid: FirebaseAuth.instance.currentUser!.uid,
                            req_point: points,
                            status: "not verified",
                            regno: regno!,
                            name: name!,
                            activity_category: selectedCategory.toString(),
                            activity: selectedActivity.toString(),
                            date: _dateController.text.toString(),
                            description: _descriptionController.text,
                            context: context,
                          );
                          setState(() {
                            _dateController.clear();
                            _descriptionController.clear();
                            selectedActivity = null;
                            selectedCategory = null;
                            log("Cleared");
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800], // Dark blue button
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
