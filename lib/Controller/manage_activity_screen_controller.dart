import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageActivityScreenController with ChangeNotifier {
  Future<void> changeOrderStatus({
    required String comment,
    required String updatedStatus,
    required String userid,
    required String ordereditemid,
    required num req_points,
  }) async {
    if (updatedStatus.isEmpty) {
      log("All fields are required.");
      return;
    }

    try {
      // Reference to the activity document
      final activityDocRef = FirebaseFirestore.instance
          .collection('activities')
          .doc(userid)
          .collection('uploads')
          .doc(ordereditemid);

      // Fetch the current status of the activity
      final activityDoc = await activityDocRef.get();
      final currentStatus = activityDoc['status'] ?? 'not verified';

      // Reference to the user's document
      final userDocRef = FirebaseFirestore.instance
          .collection('users') // Replace with your users collection name
          .doc(userid);

      // Fetch the current total_points
      final userDoc = await userDocRef.get();
      final currentTotalPoints = userDoc['total_points'] ?? 0;

      // Calculate the new total_points based on the status transition
      num newTotalPoints = currentTotalPoints;

      if (currentStatus == 'not verified') {
        if (updatedStatus == 'accepted') {
          // Add req_points when transitioning from pending to accepted
          newTotalPoints = currentTotalPoints + req_points;
        } else if (updatedStatus == 'declined') {
          // Do not change total_points when declining
          newTotalPoints = currentTotalPoints;
        }
      } else if (currentStatus == 'accepted' && updatedStatus == 'declined') {
        // Subtract req_points when transitioning from accepted to declined
        newTotalPoints = currentTotalPoints - req_points;
      } else if (currentStatus == 'declined' && updatedStatus == 'accepted') {
        // Add req_points when transitioning from declined to accepted
        newTotalPoints = currentTotalPoints + req_points;
      }

      // Update the status of the activity
      await activityDocRef.update({
        'comments': comment,
        'status': updatedStatus,
      });

      // Update the user's total_points
      await userDocRef.update({
        'total_points': newTotalPoints,
      });

      log("Status and total points updated successfully.");
    } catch (e) {
      log("Failed to update status and total points.");
      log(e.toString());
    }
  }
}
