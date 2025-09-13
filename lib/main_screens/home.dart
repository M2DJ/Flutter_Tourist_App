import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/profile.dart.dart';
import 'package:my_governate_app/main_screens/search.dart';
import 'package:my_governate_app/main_screens/timeline.dart';
import 'package:my_governate_app/widgets/custom_app_bar.dart';
import 'package:my_governate_app/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;

  final List<Widget> _pages = const [TimelineScreen(), Search(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),

      appBar: const CustomAppBar(),

      body: _pages[_selectedIndex],
      // bottomNavigationBar: ClipRRect(

      //   borderRadius:  BorderRadius.vertical(
      //     top: Radius.circular(30)
      //   ),

      //   child: CustomNavBar(
      // currentIndex: _selectedIndex,
      // onTap: (index) {
      //   setState(() {
      //     _selectedIndex = index;
      //   });
      // },
      // ),),
    );
  }
}
