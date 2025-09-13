import 'package:flutter/material.dart';
import 'package:my_governate_app/Intro/splash_screen.dart';
import 'package:my_governate_app/provider/state_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<StateProvider>(
      create: (_) => StateProvider(),
      child: const MyGovernate(),
    ),
  );
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
      home: const SplashScreen(),
    );
  }
}
