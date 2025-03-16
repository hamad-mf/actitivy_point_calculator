import 'package:actitivy_point_calculator/Controller/login_screen_controller.dart';
import 'package:actitivy_point_calculator/Controller/registration_screen_controller.dart';
import 'package:actitivy_point_calculator/View/Login%20Screen/login_screen.dart';
import 'package:actitivy_point_calculator/View/Registration%20Screen/registration_screen.dart';

import 'package:actitivy_point_calculator/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => RegistrationScreenController()),
        ChangeNotifierProvider(create: (context) => LoginScreenController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RegistrationScreen(),
      ),
    );
  }
}
