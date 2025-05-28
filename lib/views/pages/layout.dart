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
      backgroundColor: Color(0xffeff4fd),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0)
        ),
        child: Theme(
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
                  child: SvgPicture.asset(
                    "assets/icons/menu.svg",
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      Colors.blueGrey[200]!.withValues(alpha: 0.9),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: SvgPicture.asset(
                    "assets/icons/menu.svg",
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      Colors.indigoAccent.shade400,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.squarePollVertical),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: SvgPicture.asset(
                    "assets/icons/user.svg",
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      Colors.blueGrey[200]!.withValues(alpha: 0.9),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: SvgPicture.asset(
                    "assets/icons/user.svg",
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      Colors.indigoAccent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                label: "",
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: contentOptions),
    );
  }
}
