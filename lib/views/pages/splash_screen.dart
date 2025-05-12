import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quizzie/views/pages/access_choice.dart';
import 'package:quizzie/views/pages/home.dart';
import 'package:quizzie/views/pages/login_page.dart';
import 'package:quizzie/views/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _cusInit();
  }

  Future<void> _cusInit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await secureStorage.read(key: 'token');
    final hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;
    if (!mounted) return;
    if (!hasSeenWelcome) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } else if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccessChoice()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
