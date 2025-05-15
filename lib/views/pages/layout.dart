import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/views/styles/common_appbar_title_style.dart';
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

  List<AppBar> get _appBars => [
    AppBar(
      title: Column(children: [Text("$name", style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w700,))]),
      backgroundColor: Colors.blueAccent.shade100,
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/racool.jpg'),
      ),
    ),
    AppBar(title: Column(children: [Text("")])),
    AppBar(
      backgroundColor: Colors.white,
      title: Text("Profile", style: appbarTitleStyle()),
      centerTitle: true,
      actionsPadding: EdgeInsets.only(bottom: 3.0),
      actions: [
        IconButton(
          onPressed: () {},
          icon: FaIcon(FontAwesomeIcons.solidMoon, size: 20.0),
        ),
      ],
    ),
  ];

  Future<void> _loadUserData() async {
    final storedName = await UserDataStorageService().get("name");
    final storedEmail = await UserDataStorageService().get("email");

    setState(() {
      name = storedName;
      email = storedEmail;
    });
  }

  List<Widget> get contentOptions => <Widget>[
    QuizMenu(),
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
      appBar: _appBars.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          iconSize: 30.0,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.white,
          onTap: _onIconTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          unselectedIconTheme: IconThemeData(
            color: Colors.blueGrey.shade400.withValues(alpha: 0.3),
          ),
          selectedItemColor: Colors.indigoAccent,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: FaIcon(FontAwesomeIcons.cubes),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.squarePollVertical),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidUser),
              label: "",
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: IndexedStack(index: _selectedIndex, children: contentOptions),
      ),
    );
  }
}
