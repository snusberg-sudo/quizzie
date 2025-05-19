import 'package:flutter/material.dart';

class MyActionIconButton extends StatelessWidget {
  const MyActionIconButton({super.key, required this.icon, required this.onPressed});

  final Widget icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: Colors.white,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade100.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
