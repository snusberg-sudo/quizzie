import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizProgressCircle extends StatefulWidget {
  const QuizProgressCircle({
    super.key,
    required this.completedQuiz,
    required this.totalQuiz,
  });

  final int completedQuiz, totalQuiz;

  @override
  State<QuizProgressCircle> createState() => _QuizProgressCircleState();
}

class _QuizProgressCircleState extends State<QuizProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.completedQuiz / widget.totalQuiz,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 93.5,
              height: 93.5,
              child: CircularProgressIndicator(
                value: _progressAnimation.value,
                strokeWidth: 4.5,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.deepPurple[50]!.withValues(alpha: 0.8),
                valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
              ),
            ),
            Text(
              "${widget.completedQuiz}/${widget.totalQuiz}",
              style: GoogleFonts.inter(
                fontSize: 24.5,
                fontWeight: FontWeight.bold,
                color: Colors.indigoAccent,
              ),
            ),
          ],
        );
      },
    );
  }
}
