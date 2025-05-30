import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color progressColor;
  final Color progressBorderColor;
  final double height;
  final Duration duration;
  final Curve curve;

  const CustomProgressBar({
    super.key,
    required this.value,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.indigoAccent,
    this.progressBorderColor = Colors.black87,
    this.height = 10.0,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                curve: curve,
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: progressColor,
                  border: Border.all(color: progressBorderColor, width: 1.25),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
