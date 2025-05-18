import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.quizAsgnId});

  final int quizAsgnId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MyAppbar(
            title: Text(
              '',
              style: GoogleFonts.robotoFlex(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 22.5,
              ),
            ),
            leading: null,
            actions: null,
          ),
        ],
      ),
    );
  }
}
