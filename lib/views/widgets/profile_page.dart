import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/views/pages/login_page.dart';
import 'package:quizzie/views/widgets/list_view_navigation.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.name, required this.email});

  final String? name;
  final String? email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          MyAppbar(
            expandedHeight: 240.0,
            centerTitle: true,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage('assets/images/racool.jpg'),
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  widget.name ?? 'Dummy Name',
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.5,
                    letterSpacing: -0.4,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3.0),
                Text(
                  widget.email ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.5,
                    letterSpacing: -0.4,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            children: [
              SizedBox(height: 22.0),
              ListViewNavigation(
                widgetsList: [
                  {
                    'icon': FontAwesomeIcons.gear,
                    'text': "Settings",
                    'trailingAction': () {},
                  },
                  {
                    'icon': FontAwesomeIcons.chartSimple,
                    'text': "Statistics",
                    'trailingAction': () {},
                  },
                  {
                    'icon': FontAwesomeIcons.trophy,
                    'text': "Achievements",
                    'trailingAction': () {},
                  },
                ],
              ),
              Divider(
                indent: 25.0,
                endIndent: 25.0,
                thickness: 0.75,
                color: Colors.grey.shade100,
              ),
              ListViewNavigation(
                widgetsList: [
                  {
                    'icon': FontAwesomeIcons.rightFromBracket,
                    'text': "ログアウト",
                    'action': () {
                      UserDataStorageService().clearAuth();
                      Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  LoginPage(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 300),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    'textColor': Colors.redAccent,
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
