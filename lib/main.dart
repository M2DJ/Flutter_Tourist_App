import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_governate_app/Intro/splash_screen.dart';
import 'package:my_governate_app/providers/data_provider.dart';
import 'package:my_governate_app/providers/state_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => StateProvider()),
      ChangeNotifierProvider(create: (_) => DataProvider()),
    ],
    child: const MyGovernate(),
  ));
}

class MyGovernate extends StatelessWidget {
  const MyGovernate({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Governate App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
