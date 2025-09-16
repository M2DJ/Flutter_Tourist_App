import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/search.dart';
import 'package:my_governate_app/main_screens/timeline.dart';
import 'package:my_governate_app/profile/profile.dart';
import 'package:my_governate_app/widgets/custom_app_bar.dart';
import 'package:my_governate_app/widgets/custom_drawer.dart';
import 'package:my_governate_app/widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TimelineScreen(),
    Search(),
    Profile(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: CustomNavBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onNavItemTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
