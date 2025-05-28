import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewChoiceTile extends StatelessWidget {
  const ReviewChoiceTile({
    super.key,
    required this.isChoice,
    required this.seeExplanation,
    required this.choice,
    required this.isSkipped,
  });

  final bool isChoice, isSkipped;
  final VoidCallback seeExplanation;
  final Map<String, dynamic>? choice;

  Color? determineCardColor() {
    if (choice!['is_correct'] && !isSkipped) {
      return Colors.green.shade200.withValues(alpha: 0.3);
    } else if (isChoice && !choice!["is_correct"]) {
      return Colors.red.shade200.withValues(alpha: 0.4);
    } else if (!isChoice && isSkipped && choice!['is_correct']) {
      return Colors.amber.shade200.withValues(alpha: 0.3);
    }
    return Colors.grey.shade100;
  }

  Color? determineColor() {
    if (choice!['is_correct'] && !isSkipped) {
      return Colors.greenAccent.shade700;
    } else if (isChoice && !choice!["is_correct"]) {
      return Colors.redAccent;
    } else if (!isChoice && isSkipped && choice!['is_correct']) {
      return Colors.amberAccent.shade400;
    }
    return Colors.black87;
  }

  Color determineBorderColor() {
    if (choice!['is_correct'] && !isSkipped) {
      return Colors.greenAccent.shade700;
    } else if (isChoice && !choice!["is_correct"]) {
      return Colors.redAccent;
    } else if (!isChoice && isSkipped && choice!['is_correct']) {
      return Colors.amberAccent;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: determineCardColor(),
      margin: EdgeInsets.only(bottom: 17.5),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(
        color: determineBorderColor(),
        width: 1.5,
      )),
      child: ListTile(
        minTileHeight: 20.0,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          choice!["choice_text"] ?? "Dummy Text Dummy Text",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: determineColor(),
            fontSize: 13.5,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}
