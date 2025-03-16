import 'dart:developer';

import 'package:actitivy_point_calculator/Utils/app_utils.dart';
import 'package:actitivy_point_calculator/View/Admin%20Screen/admin_screen.dart';
import 'package:actitivy_point_calculator/View/Custom%20Bottom%20NavigationBar/custom_bottom_nabar_screen.dart';
import 'package:actitivy_point_calculator/View/Home%20Screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController with ChangeNotifier {
  bool isloading = false;
  onLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get the UID
      String uid = credential.user!.uid;

      //fetch the role
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      //check the role
      if (userDoc.exists) {
        String role = userDoc['role'];
        log(role);

        if (role == 'user') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => CustomBottomNabarScreen(),
            ),
            (route) => false,
          );
        } else if (role == 'admin') {
          AppUtils.showOnetimeSnackbar(
              context: context, message: "check the credentials");
        }
      }

      log(credential.user?.email.toString() ?? " no data");
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
      if (e.code == 'invalid-email') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
