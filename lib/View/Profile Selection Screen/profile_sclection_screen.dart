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
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.amber, border: Border.all(width: 3)),
                child: Center(child: Text("Teacher")),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.amber, border: Border.all(width: 3)),
                child: Center(child: Text("students")),
              )
            ],
          )
        ],
      ),
    );
  }
}
