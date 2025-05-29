import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

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
    final displayValue =
        mode == "latest" ? qaCount.toString() : '$score/$qaCount';
    final circularValue = mode == "latest" ? 0.0 : score / qaCount;

    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     SizedBox(
    //       width: 45,
    //       height: 45,
    //       child: CircularProgressIndicator(
    //         value: circularValue,
    //         strokeWidth: 3,
    //         strokeCap: StrokeCap.round,
    //         backgroundColor: Colors.deepPurple[50]!.withValues(alpha: 0.8),
    //         valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
    //       ),
    //     ),
    //     Text(
    //       displayValue,
    //       style: GoogleFonts.inter(
    //         fontSize: 13,
    //         fontWeight: FontWeight.bold,
    //         color: Colors.indigoAccent,
    //       ),
    //     ),
    //   ],
    // );
    return SizedBox(
      width: 30,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score.toString(),
            style: GoogleFonts.inter(
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
            style: GoogleFonts.inter(
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
