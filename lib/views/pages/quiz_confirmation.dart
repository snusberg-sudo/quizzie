import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/views/pages/quiz_screen.dart';

class QuizConfirmation extends StatelessWidget {
  const QuizConfirmation({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quiz.title,
            style: GoogleFonts.robotoFlex(
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
          ),
          SizedBox(height: 10),
          Text(
            quiz.description,
            style: GoogleFonts.robotoFlex(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              fontSize: 16.0,
            ),
          ),
          Lottie.asset('assets/lottie/quiz.json'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size(0, 55.0),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "Start Quiz",
                    style: GoogleFonts.robotoFlex(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QuizScreen(quiz: quiz)),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
