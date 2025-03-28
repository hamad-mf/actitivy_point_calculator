import 'package:actitivy_point_calculator/Controller/admin_login_screen_controller.dart';
import 'package:actitivy_point_calculator/Controller/login_screen_controller.dart';
import 'package:actitivy_point_calculator/Controller/manage_activity_screen_controller.dart';
import 'package:actitivy_point_calculator/Controller/registration_screen_controller.dart';
import 'package:actitivy_point_calculator/Controller/upload_image_controller.dart';
import 'package:actitivy_point_calculator/Controller/your_activities_screen_controller.dart';
import 'package:actitivy_point_calculator/View/Splash%20Screen/splash_screen.dart';

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
        ChangeNotifierProvider(create: (context) => UploadImageController()),
        ChangeNotifierProvider(
            create: (context) => AdminLoginScreenController()),
        ChangeNotifierProvider(
            create: (context) => YourActivitiesScreenController()),
            ChangeNotifierProvider(
            create: (context) => ManageActivityScreenController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
