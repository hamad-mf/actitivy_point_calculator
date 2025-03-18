import 'package:actitivy_point_calculator/Controller/admin_login_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
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
            context.watch<AdminLoginScreenController>().isloading
                ? CircularProgressIndicator.adaptive()
                : ElevatedButton(
                    onPressed: () async {
                      await context.read<AdminLoginScreenController>().onLogin(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context);

                      emailController.clear();
                      passwordController.clear();
                    },
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
