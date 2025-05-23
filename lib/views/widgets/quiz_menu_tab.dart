import 'package:flutter/material.dart';
import 'package:quizzie/views/widgets/quiz_sliver_list.dart';

class QuizMenuTab extends StatefulWidget {
  const QuizMenuTab({super.key, required this.snapshot});

  final AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot;

  @override
  State<QuizMenuTab> createState() => _QuizMenuTabState();
}

class _QuizMenuTabState extends State<QuizMenuTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          TabBar(tabs: [Tab(text: "Latest"), Tab(text: "History")]),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: QuizSliverList(snapshot: widget.snapshot,)),
                Center(child: Text("History")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
