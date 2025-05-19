import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizProgressCircle extends StatelessWidget {
  const QuizProgressCircle({
    super.key,
    required this.completedQuiz,
    required this.totalQuiz,
  });

  final int completedQuiz, totalQuiz;

  @override
  Widget build(BuildContext context) {
    double progress = completedQuiz / totalQuiz;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 37.5,
          height: 37.5,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey.shade200.withValues(alpha: 0.9),
            valueColor: AlwaysStoppedAnimation(progress < 1.0 ? Colors.amber.shade300.withValues(alpha: 0.65) : Colors.green),
          ),
        ),
        Text("$completedQuiz/$totalQuiz", style: GoogleFonts.robotoFlex(
          fontSize: 13.5,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),)
      ],
    );
  }
}
