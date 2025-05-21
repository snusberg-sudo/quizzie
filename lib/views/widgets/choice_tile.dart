import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChoiceTile extends StatefulWidget {
  final bool isChoice;
  final bool hasData;
  final Map<String, dynamic>? choice;
  final VoidCallback handleTap;

  const ChoiceTile({super.key, required this.hasData, required this.isChoice, required this.choice, required this.handleTap});

  @override
  State<ChoiceTile> createState() => _ChoiceTileState();
}

class _ChoiceTileState extends State<ChoiceTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isChoice ? Colors.green : Colors.white,
      margin: EdgeInsets.only(bottom: 17.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        minTileHeight: 20.0,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          widget.hasData ? widget.choice!["choice_text"] : "Dummy Text Dummy Text",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: widget.isChoice ? Colors.white : Colors.black87,
            fontSize: 13.5,
          ),
        ),
        onTap: widget.handleTap,
      ),
    );
  }
}
