import 'package:flutter/material.dart';

class MyActionIconButton extends StatelessWidget {
  const MyActionIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.borderSide = BorderSide.none,
    this.borderRadiusGeometry = BorderRadius.zero,
    this.backgroundColor
  });

  final Widget icon;
  final void Function() onPressed;
  final BorderSide borderSide;
  final BorderRadiusGeometry borderRadiusGeometry;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: Colors.white,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusGeometry,
          side: borderSide,
        ),
      ),
    );
  }
}
