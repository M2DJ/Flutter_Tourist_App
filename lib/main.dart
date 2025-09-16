import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_governate_app/Intro/splash_screen.dart';
import 'package:my_governate_app/main_screens/home.dart';
import 'package:my_governate_app/providers/data_provider.dart';
import 'package:my_governate_app/providers/app_state_provider.dart';
import 'package:my_governate_app/providers/notification_provider.dart';
import 'package:my_governate_app/services/auth_service.dart';
import 'package:my_governate_app/services/google_signin_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Sign-In Service
  await GoogleSignInService().initialize();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ChangeNotifierProvider(create: (_) => DataProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ],
    child: const MyGovernate(),
  ));
}

class MyGovernate extends StatefulWidget {
  const MyGovernate({super.key});

  @override
  State<MyGovernate> createState() => _MyGovernateState();
}

class _MyGovernateState extends State<MyGovernate> {
  bool? isLoggedIn;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    try {
      final loggedIn = await _authService.isUserLoggedIn();
      setState(() {
        isLoggedIn = loggedIn;
      });
      print("Login state checked: $loggedIn");
    } catch (e) {
      print("Error checking login state: $e");
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Governate App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        useMaterial3: true,
      ),
      home: isLoggedIn == null
          ? const SplashScreen() // Show splash while checking
          : (isLoggedIn! ? const HomePage() : const SplashScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}
