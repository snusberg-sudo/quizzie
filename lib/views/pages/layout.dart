import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/views/widgets/leaderboard.dart';
import 'package:quizzie/views/widgets/profile_page.dart';
import 'package:quizzie/views/widgets/quiz_menu.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  String? name, email;

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadUserData() async {
    final storedName = await UserDataStorageService().get("name");
    final storedEmail = await UserDataStorageService().get("email");

    setState(() {
      name = storedName;
      email = storedEmail;
    });
  }

  List<Widget> get contentOptions => <Widget>[
    QuizMenu(name: name),
    Leaderboard(),
    ProfilePage(name: name, email: email),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: contentOptions),
    );
  }
}
