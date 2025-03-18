import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class YourActivitiesScreenController with ChangeNotifier {
  bool _isloading = false;

  bool get isloading => _isloading;

  //fetch  the activites that are submitted  for the logged in user
  Stream<QuerySnapshot> getUserActivitiesStream(String userId) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(userId)
        .collection('uploads')
        .snapshots();
  }




  
}
