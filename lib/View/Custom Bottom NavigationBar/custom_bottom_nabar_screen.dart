import 'package:actitivy_point_calculator/View/Home%20Screen/home_screen.dart';
import 'package:actitivy_point_calculator/View/Profile%20Screen/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNabarScreen extends StatefulWidget {
  const CustomBottomNabarScreen({super.key});

  @override
  State<CustomBottomNabarScreen> createState() =>
      _CustomBottomNabarScreenState();
}

class _CustomBottomNabarScreenState extends State<CustomBottomNabarScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        items: <Widget>[
          Column(
            children: [Icon(Icons.home, size: 30), Text("Home")],
          ),
          Column(
            children: [Icon(Icons.person, size: 30), Text("Profile")],
          ),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
