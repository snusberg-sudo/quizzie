import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/data/utils/decider_for_score.dart';
import 'package:quizzie/views/widgets/quiz_progress_circle.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizScore extends StatefulWidget {
  const QuizScore({
    super.key,
    required this.quizId,
    required this.selectedChoices,
    required this.quizCount,
  });

  final int quizId, quizCount;
  final List<Map> selectedChoices;

  @override
  State<QuizScore> createState() => _QuizScoreState();
}

class _QuizScoreState extends State<QuizScore> {
  Future<int>? _score;
  String? name, title, message;
  
  Future<void> getUserName() async {
    final storedName = await UserDataStorageService().get("name");
    setState(() {
      name = storedName;
    });
  }

  Future<int> _postAnswers() async {
    final apiService = ApiService();
    try {
      final response = await apiService.post(
        '/user/quiz-assignments/${widget.quizId}/answers',
        {"answers": widget.selectedChoices},
      );
      return response.data["score"];
    } catch (error) {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _score = _postAnswers();

    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _score,
        builder: (context, snapshot) {
          final isLoading = !snapshot.hasData;
          final result = !isLoading ? DeciderForScore(score: snapshot.data ?? 0, totalQuiz: widget.quizCount) : null;
          return Skeletonizer(
            enabled: isLoading,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    "あなたのスコア",
                    style: GoogleFonts.rubik(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  QuizProgressCircle(
                    completedQuiz: snapshot.hasData ? snapshot.data! : 0,
                    totalQuiz: widget.quizCount,
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    !isLoading ? result!.title : "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      fontSize: 25.5,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    !isLoading ? result!.message : "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      fontSize: 14.5,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Spacer(),
                  Padding(
                  padding: EdgeInsets.all(35.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.amberAccent.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.black87, width: 1.25)
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "メニューに戻る",
                        style: GoogleFonts.rubik(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87
                        ),
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
