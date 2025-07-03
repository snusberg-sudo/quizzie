import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/data/models/quiz.dart';

class QuizDataState {
  final List items;
  final bool isLoading;
  final String? error;

  QuizDataState({this.items = const [], this.isLoading = false, this.error});

  QuizDataState copyWith({List? items, bool? isLoading, String? error}) {
    return QuizDataState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class QuizDataNotifier extends StateNotifier<QuizDataState> {
  final Ref ref;

  QuizDataNotifier(this.ref) : super(QuizDataState()) {
    loadData();
  }

  Future<void> loadData() async {
    if (state.isLoading) return;
    await Future.delayed(Duration.zero);
    state = state.copyWith(isLoading: true, error: null);
    final apiService = ref.read(apiServiceProvider);

    try {
      final response = await apiService.get('/user/quiz-assignments');
      state = state.copyWith(items: response.data['data'], isLoading: false);
      print(response.data['data']);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearData() {
    state = state.copyWith(items: [], isLoading: false, error: null);
  }

  Future<void> refreshData() async {
    clearData();
    await loadData();
  }
}

final quizDataProvider =
    StateNotifierProvider.autoDispose<QuizDataNotifier, QuizDataState>((ref) {
      return QuizDataNotifier(ref);
    });

final latestQuizProvider = Provider((ref) {
  final quizDataState = ref.watch(quizDataProvider);
  return quizDataState.items
      .where((item) => item['score'] == 0 && item['completed_at'] == null)
      .toList();
});

final historyQuizProvider = Provider((ref) {
  final quizDataState = ref.watch(quizDataProvider);
  return quizDataState.items
      .where((item) => item['completed_at'] != null)
      .toList();
});
