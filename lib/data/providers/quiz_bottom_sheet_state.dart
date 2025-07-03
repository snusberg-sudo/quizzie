import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizBottomSheetState {
  final int? quizId;
  final int? quizAssignmentId;
  final String? quizTitle;
  final String? quizDesc;
  final int? qaCount;
  final String? completedAt;
  final int? score;
  final String? category;

  QuizBottomSheetState({
    this.quizId,
    this.quizAssignmentId,
    this.quizTitle,
    this.quizDesc,
    this.qaCount,
    this.completedAt,
    this.score,
    this.category
  });
}

class QuizBottomSheetStateNotifier
    extends FamilyNotifier<QuizBottomSheetState, Map<String, dynamic>> {
  @override
  QuizBottomSheetState build(Map<String, dynamic> quizData) {
    return QuizBottomSheetState(
      quizId: quizData['id'],
      quizAssignmentId: quizData['quiz']['id'],
      quizTitle: quizData['quiz']['title'],
      quizDesc: quizData['quiz']['description'],
      qaCount: quizData['quiz']['questions_count'],
      completedAt: quizData['completed_at'],
      score: quizData['score'],
      category: quizData['quiz']['category']['name']
    );
  }
}

final quizBSSNotifierProvider = NotifierProvider.family<
  QuizBottomSheetStateNotifier,
  QuizBottomSheetState,
  Map<String, dynamic>
>(() => QuizBottomSheetStateNotifier());
