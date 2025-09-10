import 'package:flutter/material.dart';
import 'package:my_governate_app/Intro/splash_screen.dart';

void main() {
  runApp(const MyGovernate());
}

class MyGovernate extends StatelessWidget {
  const MyGovernate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}