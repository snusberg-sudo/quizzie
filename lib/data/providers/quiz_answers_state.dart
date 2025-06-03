import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizAnswersNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  QuizAnswersNotifier() : super([]);

  void selectAnswer(int questionId, dynamic choiceId) {
    final existingIndex = state.indexWhere(
      (entry) => entry['question_id'] == questionId,
    );

    if (existingIndex != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            {'question_id': questionId, 'choice_id': choiceId}
          else
            state[i],
      ];
    } else {
      state = [
        ...state,
        {'question_id': questionId, 'choice_id': choiceId},
      ];
    }
  }

  void clear() {
    state = [];
  }
}

final quizAnswersProvider = StateNotifierProvider.autoDispose<
  QuizAnswersNotifier,
  List<Map<String, dynamic>>
>((ref) {
  return QuizAnswersNotifier();
});
