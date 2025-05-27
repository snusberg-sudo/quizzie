import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizzie/views/widgets/quiz_sliver_list.dart';

class QuizMenuTab extends ConsumerStatefulWidget {
  const QuizMenuTab({super.key});

  @override
  ConsumerState<QuizMenuTab> createState() => _QuizMenuTabState();
}

class _QuizMenuTabState extends ConsumerState<QuizMenuTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.quiz_outlined)),
              Tab(icon: Icon(Icons.history)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: QuizSliverList(mode: "latest")),
                Center(child: QuizSliverList(mode: "history")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
