
import 'package:actitivy_point_calculator/View/Admin%20Login%20Screen/admin_login_screen.dart';
import 'package:actitivy_point_calculator/View/Login%20Screen/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileSclectionScreen extends StatelessWidget {
  const ProfileSclectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminLoginScreen(),
                      ));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.amber, border: Border.all(width: 3)),
                  child: Center(
                      child: Text(
                    "Teacher",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.amber, border: Border.all(width: 3)),
                  child: Center(
                      child: Text("students",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
