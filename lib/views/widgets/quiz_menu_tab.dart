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
          Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey[350]!.withValues(alpha: 0.5),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(25.0),
                right: Radius.circular(25.0),
              ),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorPadding: EdgeInsetsGeometry.only(top: 0.1),
              indicatorSize: TabBarIndicatorSize.tab,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateColor.resolveWith((Set states) {
                return Colors.transparent;
              }),
              indicator: BoxDecoration(
                border: BoxBorder.all(
                  color: Colors.black87,
                  width: 1.5
                ),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(25.0),
                  right: Radius.circular(25.0),
                ),
                color: Colors.amberAccent.shade400,
              ),
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey.withValues(alpha: 0.7),
              tabs: [
                Tab(icon: Icon(Icons.quiz_outlined, size: 27.0,)),
                Tab(icon: Icon(Icons.history, size: 27.0,)),
              ],
            ),
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
