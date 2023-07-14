import 'package:firebase_core/firebase_core.dart';
import 'package:firezup/pages/auth/login_page.dart';
import 'package:firezup/pages/home_page.dart';
import 'package:firezup/services/auth_service.dart';
import 'package:firezup/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/app_firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "dotenv");

  await Firebase.initializeApp(
    options: AppFirebaseOptions.getForCurrentPlatform(),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    bool res = authService.isLoggedIn();
    setState(() => _isLoggedIn = res);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isLoggedIn ? const HomePage() : const LoginPage(),
      theme: appTheme,
    );
  }
}
