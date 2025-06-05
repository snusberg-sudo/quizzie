import 'package:flutter/material.dart';

class OutlinedLogoButton extends StatelessWidget {
  const OutlinedLogoButton({super.key, required this.logoPath, required this.logoWidth, required this.logoHeight});
  final String logoPath;
  final double logoWidth, logoHeight;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.black87, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        minimumSize: Size(100.0, 65.0),
      ),
      child: Image.asset(logoPath, width: logoWidth, height: logoHeight),
    );
  }
}
