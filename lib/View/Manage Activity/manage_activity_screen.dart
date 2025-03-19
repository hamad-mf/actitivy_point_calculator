import 'package:flutter/material.dart';

class ManageActivityScreen extends StatefulWidget {
  final String studentName;
  final String registerNo;
  final String activityName;
  final String activityCategoryName;
  final String date;
  final String description;
  final String img_url;
  final num req_points;
  final String status;

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
  });

  @override
  State<ManageActivityScreen> createState() => _ManageActivityScreenState();
}

class _ManageActivityScreenState extends State<ManageActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Activity"),
        backgroundColor: Colors.blue,
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
                  _buildDetailRow("Student Name", widget.studentName),
                  _buildDetailRow("Register Number", widget.registerNo),
                  _buildDetailRow("Category", widget.activityCategoryName),
                  _buildDetailRow("Activity", widget.activityName),
                  _buildDetailRow("Date", widget.date),
                  _buildDetailRow(
                      "Required Points", widget.req_points.toString()),
                  _buildDetailRow("Status", widget.status),
                  SizedBox(height: 12),
                  Text(
                    "Description:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  if (widget.img_url.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(imageUrl: widget.img_url),
                          ),
                        );
                      },
                      child: Hero(
                        tag: "fullScreenImage",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.img_url,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                  child: Text("Image failed to load"));
                            },
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      ElevatedButton(onPressed: () {}, child: Text("Accept")),
                      ElevatedButton(onPressed: () {}, child: Text("Decline")),
                    ],
                  )
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
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
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                        child: Text("Image failed to load",
                            style: TextStyle(color: Colors.white)));
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
