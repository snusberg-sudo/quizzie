import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewChoiceTile extends StatelessWidget {
  const ReviewChoiceTile({
    super.key,
    required this.isChoice,
    required this.seeExplanation,
    required this.choice,
    required this.isSkipped,
    required this.alphaIndex,
  });

  final bool isChoice, isSkipped;
  final VoidCallback seeExplanation;
  final String alphaIndex;
  final Map<String, dynamic>? choice;

  Color? determineCardColor() {
    if (isChoice) {
      return Colors.amberAccent.shade400;
    }
    return Colors.white;
  }

  Color determineBorderColor() {
    if (isChoice) {
      return Colors.black87;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: determineCardColor(),
      margin: EdgeInsets.only(bottom: 17.5),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(color: determineBorderColor(), width: 1.5),
      ),
      child: ListTile(
        leading: Text(
          "$alphaIndex.",
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 19.5,
            letterSpacing: -0.6,
          ),
        ),
        minTileHeight: 20.0,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          choice!["choice_text"] ?? "Dummy Text Dummy Text",
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 16.5,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}
