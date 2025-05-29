import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChoiceTile extends StatefulWidget {
  final bool isChoice, hasData;
  final Map<String, dynamic>? choice;
  final VoidCallback handleTap;
  final String alphaChoice;

  const ChoiceTile({
    super.key,
    required this.hasData,
    required this.isChoice,
    required this.choice,
    required this.handleTap,
    required this.alphaChoice,
  });

  @override
  State<ChoiceTile> createState() => _ChoiceTileState();
}

class _ChoiceTileState extends State<ChoiceTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: widget.isChoice ? Colors.amberAccent.shade400 : Colors.white,
      margin: EdgeInsets.only(bottom: 17.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side:
            widget.isChoice
                ? BorderSide(color: Colors.black87, width: 2)
                : BorderSide(
                  color: Colors.grey.shade100.withValues(alpha: 0.6),
                  width: 2,
                ),
      ),
      child: ListTile(
        leading: Text(
          "${widget.alphaChoice}.",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 19.5,
            letterSpacing: -0.6,
          ),
        ),
        splashColor: Colors.transparent,
        minTileHeight: 20.0,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          widget.hasData
              ? widget.choice!["choice_text"]
              : "Dummy Text Dummy Text",
          style: GoogleFonts.inter(
            fontWeight: widget.isChoice ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
            fontSize: 17.5,
            letterSpacing: -0.6,
          ),
        ),
        onTap: widget.handleTap,
      ),
    );
  }
}
