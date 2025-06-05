import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizzie/api/api_service.dart';

class QuizResultReviewState {
  final List items;
  final bool isLoading;
  final String? error;

  QuizResultReviewState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  QuizResultReviewState copyWith({
    List? items,
    bool? isLoading,
    String? error,
  }) {
    return QuizResultReviewState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class QuizResultReviewNotifier extends StateNotifier<QuizResultReviewState> {
  final int quizId;
  final Ref ref;

  QuizResultReviewNotifier(this.quizId, this.ref)
    : super(QuizResultReviewState()) {
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(Duration.zero);
    state = state.copyWith(isLoading: true, error: null);
    final apiService = ref.read(apiServiceProvider);

    try {
      final response = await apiService.get(
        '/user/quiz-assignments/$quizId/results',
      );
      state = state.copyWith(
        items: response.data['data']['quiz']['questions'],
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

final quizResultReviewProvider = StateNotifierProvider.autoDispose
    .family<QuizResultReviewNotifier, QuizResultReviewState, int>((
      ref,
      quizId,
    ) {
      return QuizResultReviewNotifier(quizId, ref);
    });
