import 'dart:io';
import 'package:pdf/widgets.dart' as pw; // Use 'pw' as an alias
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class GenerateReportsScreen extends StatelessWidget {
  const GenerateReportsScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchStudents() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'name': data['name'] ?? 'No Name',
        'register_no': data['register_no'] ?? 'No Registerno',
        'total_points': data['total_points'] ?? 0,
      };
    }).toList();
  }

  Future<void> _generatePdf(List<Map<String, dynamic>> students) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text('Student Report')),
              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['Name', 'Register No', 'Total Points'],
                  ...students.map((student) => [
                        student['name'],
                        student['register_no'],
                        student['total_points'].toString(),
                      ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/student_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    OpenFile.open(file.path);
  }

  Future<void> _generateExcel(List<Map<String, dynamic>> students) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow(['Name', 'Register No', 'Total Points']);

    // Add student data
    for (final student in students) {
      sheet.appendRow([
        student['name'],
        student['register_no'],
        student['total_points'].toString(),
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/student_report.xlsx');
    await file.writeAsBytes(excel.encode()!);

    // Open the Excel file
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Generate Your Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[900], // Dark blue app bar
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[900], // Dark blue loading indicator
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final students = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          student['name'],
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Registerno: ${student['register_no']}, Points: ${student['total_points']}",
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _generatePdf(students),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Dark blue button
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Generate PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _generateExcel(students),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Dark blue button
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Generate Excel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
