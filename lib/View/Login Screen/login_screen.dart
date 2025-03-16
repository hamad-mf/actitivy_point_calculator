import 'dart:developer';

import 'package:actitivy_point_calculator/Controller/login_screen_controller.dart';
import 'package:actitivy_point_calculator/View/Home%20Screen/home_screen.dart';
import 'package:actitivy_point_calculator/View/Registration%20Screen/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            context.watch<LoginScreenController>().isloading
                ? CircularProgressIndicator.adaptive()
                : ElevatedButton(
                    onPressed: () async {
                      await context.read<LoginScreenController>().onLogin(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context);

                      emailController.clear();
                      passwordController.clear();
                    },
                    child: Text('Login'),
                  ),
            TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text("Don't have an account, Register Now"))
          ],
        ),
      ),
    );
  }
}
