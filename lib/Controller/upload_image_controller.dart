import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:actitivy_point_calculator/Utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadImageController with ChangeNotifier {
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  File? get selectedImage => _selectedImage;
  String? get uploadedImageUrl => _uploadedImageUrl;
  bool get isUploading => _isUploading;

  // Pick an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = File(image.path);
      notifyListeners();
    }
  }

  // Upload the image to Imgur
  Future<String?> uploadImageToImgur(File imageFile) async {
    const String clientId =
        '71ef9f46d10df0e'; // Replace with your Imgur Client ID
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgur.com/3/image'),
      );

      request.headers['Authorization'] = 'Client-ID $clientId';
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final jsonData = jsonDecode(responseData.body);

      if (jsonData['success'] == true) {
        return jsonData['data']['link'];
      } else {
        log('Imgur Upload Failed: ${jsonData['data']['error']}');
      }
    } catch (e) {
      log('Error uploading image: $e');
    }
    return null;
  }

  // Save the image URL to Firestore
  Future<void> saveImageUrlToFirestore({
    required String userid,
    required num req_point,
    required String status,
    required String name,
    required String regno,
    required String activity_category,
    required String activity,
    required String date,
    required String imageUrl,
    required String userId,
    required String description,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(userId)
          .collection('uploads')
          .add({
        'userid':userid,
        'req_point':req_point,
        'status':status,
        'register_no':regno,
        'name':name,
        'activity_category': activity_category,
        'activity': activity,
        'date': date,
        'description': description,
        'image_url': imageUrl,
        'uploaded_at': FieldValue.serverTimestamp(),
      });
      log('Image URL saved to Firestore.');
    } catch (e) {
      log('Error saving image URL to Firestore: $e');
    }
  }

  // Handle the entire process: pick, upload, and save
  Future<void> uploadAndSaveImage({
    required String userid,
    required num req_point,
    required String status,
    required String regno,
    required String name,
    required String activity_category,
    required String activity,
    required String date,
    required String description,
    required BuildContext context,
  }) async {
    if (_selectedImage == null) {
      log('No image selected.');
      AppUtils.showOnetimeSnackbar(
          context: context, message: "No image selected.", bg: Colors.red);
      return;
    }

    _isUploading = true;
    notifyListeners();

    try {
      // Upload the image to Imgur
      final imageUrl = await uploadImageToImgur(_selectedImage!);
      if (imageUrl != null) {
        // Save the image URL to Firestore
        final userId = FirebaseAuth.instance.currentUser!.uid;
        await saveImageUrlToFirestore(
          userid:userid,
          req_point:req_point,
          status:status,
          regno:regno,
          name:name,
          activity: activity,
          activity_category: activity_category,
          date: date,
          imageUrl: imageUrl,
          description: description,
          userId: userId,
          context: context,
        );

        // Update the state
        _uploadedImageUrl = imageUrl;
        _selectedImage = null; // Reset the selected image
        notifyListeners();

        log('Image uploaded and saved successfully.');
        AppUtils.showOnetimeSnackbar(
            context: context,
            message: "uploaded successfully",
            bg: Colors.green);
      }
    } catch (e) {
      log('Error during image upload: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
