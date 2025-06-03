import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizResultMini extends StatelessWidget {
  const QuizResultMini({
    super.key,
    required this.qaCount,
    required this.score,
    required this.mode,
  });

  final int qaCount, score;
  final String mode;

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: 30,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score.toString(),
            style: GoogleFonts.rubik(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: Colors.indigoAccent,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1.5,
            color: Colors.amberAccent.shade400,
          ),
          Text(
            qaCount.toString(),
            style: GoogleFonts.rubik(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: Colors.amberAccent.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
