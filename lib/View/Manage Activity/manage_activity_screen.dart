
import 'package:actitivy_point_calculator/Controller/manage_activity_screen_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageActivityScreen extends StatefulWidget {
  final String? studentName;
  final String? registerNo;
  final String? activityName;
  final String? activityCategoryName;
  final String? date;
  final String? description;
  final String? img_url;
  final num? req_points;
  final String? status;
  final String? userid;
  final String? ordereditemid;

  const ManageActivityScreen({
    super.key,
    required this.studentName,
    required this.registerNo,
    required this.activityCategoryName,
    required this.activityName,
    required this.date,
    required this.description,
    required this.img_url,
    required this.req_points,
    required this.status,
    required this.userid,
    required this.ordereditemid,
  });

  @override
  State<ManageActivityScreen> createState() => _ManageActivityScreenState();
}

final TextEditingController _commentController = TextEditingController();

class _ManageActivityScreenState extends State<ManageActivityScreen> {
  bool _decisionMade = false;

  @override
  void initState() {
    super.initState();
    _fetchDecisionMade(); // Fetch decisionMade from Firestore when the screen loads
  }

  // Fetch decisionMade from Firestore
  Future<void> _fetchDecisionMade() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('activities')
          .doc(widget.userid)
          .collection('uploads')
          .doc(widget.ordereditemid)
          .get();

      if (doc.exists) {
        final decisionMade = doc['decisionMade'] ?? false;
        setState(() {
          _decisionMade = decisionMade;
        });
      }
    } catch (e) {
      print("Error fetching decisionMade: $e");
    }
  }

  // Update decisionMade in Firestore and locally
  Future<void> _updateDecision(bool decisionMade) async {
    try {
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(widget.userid)
          .collection('uploads')
          .doc(widget.ordereditemid)
          .update({'decisionMade': decisionMade});

      setState(() {
        _decisionMade = decisionMade;
      });
    } catch (e) {
      print("Error updating decisionMade: $e");
    }
  }

  // Show edit confirmation dialog
  Future<void> _showEditConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Decision'),
          content: Text('Do you want to edit your decision?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _updateDecision(false); // Reset decisionMade to false
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Manage Activity",
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Student Name", widget.studentName ?? "N/A"),
                  _buildDetailRow("Register Number", widget.registerNo ?? "N/A"),
                  _buildDetailRow("Category", widget.activityCategoryName ?? "N/A"),
                  _buildDetailRow("Activity", widget.activityName ?? "N/A"),
                  _buildDetailRow("Date", widget.date ?? "N/A"),
                  _buildDetailRow("Required Points", widget.req_points?.toString() ?? "N/A"),
                  _buildDetailRow("Status", widget.status ?? "N/A"),
                  SizedBox(height: 12),
                  Text(
                    "Description:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.description ?? "N/A",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (widget.img_url != null && widget.img_url!.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(imageUrl: widget.img_url!),
                          ),
                        );
                      },
                      child: Hero(
                        tag: "fullScreenImage",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.img_url!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue[900],
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  "Image failed to load",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                    "Add Comment(optional):",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[900],
                    ),
                  ),
                  Container(
                    height: 100,
                    child: TextFormField(
                      controller: _commentController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: "Enter...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[900]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (!_decisionMade)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Accept Button
                        ElevatedButton(
                          onPressed: () async {
                            final controller = Provider.of<ManageActivityScreenController>(context, listen: false);
                            await controller.changeOrderStatus(
                              comment: _commentController.text,
                              req_points: widget.req_points ?? 0,
                              updatedStatus: "accepted",
                              userid: widget.userid ?? "N/A",
                              ordereditemid: widget.ordereditemid ?? "N/A",
                            );

                            // Update decisionMade in Firestore
                            await _updateDecision(true);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Status updated to accepted."),
                                backgroundColor: Colors.blue[800],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800], // Dark blue button
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Accept",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Decline Button
                        ElevatedButton(
                          onPressed: () async {
                            final controller = Provider.of<ManageActivityScreenController>(context, listen: false);
                            await controller.changeOrderStatus(
                              comment: _commentController.text,
                              req_points: widget.req_points ?? 0,
                              updatedStatus: "declined",
                              userid: widget.userid ?? "N/A",
                              ordereditemid: widget.ordereditemid ?? "N/A",
                            );

                            // Update decisionMade in Firestore
                            await _updateDecision(true);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Status updated to declined."),
                                backgroundColor: Colors.blue[800],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800], // Dark blue button
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Decline",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_decisionMade)
                    Center(
                      child: ElevatedButton(
                        onPressed: _showEditConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800], // Dark blue button
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue[900],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Full-Screen Image Viewer
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: "fullScreenImage",
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue[900],
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        "Image failed to load",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}