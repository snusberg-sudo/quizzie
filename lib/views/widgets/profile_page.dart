import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizzie/views/widgets/list_view_navigation.dart';

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
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade100.withValues(alpha: 0.5),
                  width: 1.0,
                ),
              ),
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage('assets/images/racool.jpg'),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              widget.name ?? 'Dummy Name',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.5),
            ),
            SizedBox(height: 3.0),
            Text(
              widget.email ?? '',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.5),
            ),
            SizedBox(height: 22.0),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(minimumSize: Size(230.0, 50.0)),
              child: Text(
                "プロフィール編集",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.5),
              ),
            ),
            SizedBox(height: 40.0),
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
                  'text': "Logout",
                  'action': (){},
                  'textColor': Colors.redAccent
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
