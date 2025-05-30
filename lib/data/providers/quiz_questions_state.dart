import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizzie/api/api_service.dart';

class QuizQuestionsState {
  final List items;
  final bool isLoading;
  final String? error;

  QuizQuestionsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  QuizQuestionsState copyWith({List? items, bool? isLoading, String? error}) {
    return QuizQuestionsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class QuizQuestionsNotifier extends StateNotifier<QuizQuestionsState> {
  final int quizId;

  QuizQuestionsNotifier(this.quizId) : super(QuizQuestionsState()) {
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(Duration.zero);
    state = state.copyWith(isLoading: true, error: null);
    final apiService = ApiService();

    try {
      final response = await apiService.get(
        '/user/quiz-assignments/$quizId/questions',
      );
      state = state.copyWith(
        items: response.data['data'][0]['quiz']['questions'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }
}

final quizQuestionsProvider = StateNotifierProvider.autoDispose
    .family<QuizQuestionsNotifier, QuizQuestionsState, int>((ref, quizId) {
      return QuizQuestionsNotifier(quizId);
    });
