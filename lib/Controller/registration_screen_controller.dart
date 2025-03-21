import 'dart:developer';

import 'package:actitivy_point_calculator/Utils/app_utils.dart';
import 'package:actitivy_point_calculator/View/Login%20Screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class RegistrationScreenController with ChangeNotifier {
  bool isLoading = false;

  Future<void> onRegistration(
      {required String email,
      required num total_points,
      required String name,
      required String registerno,
      required String password,
      required String role,
      required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //get the uid

      String uid = credential.user!.uid;

      //store the role
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'role': role,
        'name': name,
        'register_no': registerno,
        'total_points': total_points
      });
      if (credential.user?.uid != null) {
        AppUtils.showOnetimeSnackbar(
            bg: Colors.green,
            context: context,
            message: "Registration successful");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
        // Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppUtils.showOnetimeSnackbar(
            context: context, message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showOnetimeSnackbar(
            context: context,
            message: "The account already exists for that email.");
      } else if (e.code == 'network-request-failed') {
        AppUtils.showOnetimeSnackbar(
            context: context, message: "please check your network");
      }
    } catch (e) {
      print(e);
      log(e.toString());
      AppUtils.showOnetimeSnackbar(context: context, message: e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}
