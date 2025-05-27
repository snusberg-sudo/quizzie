import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewChoiceTile extends StatelessWidget {
  const ReviewChoiceTile({
    super.key,
    required this.isChoice,
    required this.seeExplanation,
    required this.choice,
  });

  final bool isChoice;
  final VoidCallback seeExplanation;
  final Map<String, dynamic>? choice;

  Color? determineColor() {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: determineColor(),
      margin: EdgeInsets.only(bottom: 17.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        minTileHeight: 20.0,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          choice!["choice_text"] ?? "Dummy Text Dummy Text",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
