import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChoiceTile extends StatefulWidget {
  final bool isChoice, hasData;
  final Map<String, dynamic>? choice;
  final VoidCallback handleTap;

  const ChoiceTile({
    super.key,
    required this.hasData,
    required this.isChoice,
    required this.choice,
    required this.handleTap,
  });

  @override
  State<ChoiceTile> createState() => _ChoiceTileState();
}

class _ChoiceTileState extends State<ChoiceTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color:
          widget.isChoice
              ? Colors.indigoAccent.shade700.withValues(alpha: 0.3)
              : Colors.grey.shade100,
      margin: EdgeInsets.only(bottom: 17.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side:
            widget.isChoice
                ? BorderSide(color: Colors.indigoAccent, width: 1.5)
                : BorderSide.none,
      ),
      child: ListTile(
        minTileHeight: 20.0,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          widget.hasData
              ? widget.choice!["choice_text"]
              : "Dummy Text Dummy Text",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: widget.isChoice ? Colors.indigoAccent.shade400 : Colors.black87,
            fontSize: 13.5,
          ),
        ),
        onTap: widget.handleTap,
      ),
    );
  }
}
