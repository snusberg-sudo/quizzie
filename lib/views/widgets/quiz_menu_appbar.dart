import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizMenuAppbar extends StatelessWidget {
  const QuizMenuAppbar({super.key, required this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22.0)),
      ),
      backgroundColor: Colors.blueAccent.shade400.withValues(alpha: 0.6),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2.5,
        children: [
          Text(
            title ?? '',
            style: GoogleFonts.robotoFlex(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 22.5,
            ),
          ),
          Text(
            "Let's start your quiz now!",
            style: GoogleFonts.robotoFlex(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
      pinned: true,
      snap: true,
      floating: true,
      expandedHeight: 250.0,
      leadingWidth: 75.0,
      leading: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'assets/images/racool.jpg',
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(title: Text('')),
      actions: [
        IconButton(
          onPressed: () {},
          icon: FaIcon(FontAwesomeIcons.solidBell),
          color: Colors.white,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade100.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.only(right: 20.0),
    );
  }
}
