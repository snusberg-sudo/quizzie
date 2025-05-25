import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizzie/views/widgets/quiz_sliver_list.dart';

class QuizMenuTab extends StatefulWidget {
  const QuizMenuTab({super.key, required this.snapshot, required this.onRefresh});

  final AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot;
  final Future<void> Function() onRefresh;

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
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.quiz_outlined)),
              Tab(icon: Icon(Icons.history)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: QuizSliverList(snapshot: widget.snapshot, onRefresh: widget.onRefresh,)),
                Center(child: Text("History")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
