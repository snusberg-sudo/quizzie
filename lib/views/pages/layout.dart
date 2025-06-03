import 'package:flutter/material.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/views/widgets/quiz_menu.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  String? name, email;

  Future<void> _loadUserData() async {
    final storedName = await UserDataStorageService().get("name");
    final storedEmail = await UserDataStorageService().get("email");

    setState(() {
      name = storedName;
      email = storedEmail;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: QuizMenu(name: name, email: email),
    );
  }
}
