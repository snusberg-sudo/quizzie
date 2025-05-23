import 'package:flutter/material.dart';

class QuizMenuTab extends StatefulWidget {
  const QuizMenuTab({super.key});

  @override
  State<QuizMenuTab> createState() => _QuizMenuTabState();
}

class _QuizMenuTabState extends State<QuizMenuTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, initialIndex: 1, child: Column(
      children: [
        TabBar(tabs: [
          Tab(text: "Latest",),
          Tab(text: "History",)
        ]),
        TabBarView(children: [
          
        ])
      ],
    ));
  }
}
