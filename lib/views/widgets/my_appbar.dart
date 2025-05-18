import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({
    super.key,
    required this.title,
    required this.leading,
    required this.actions,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22.0)),
      ),
      backgroundColor: Colors.blueAccent.shade400.withValues(alpha: 0.6),
      title: title,
      pinned: true,
      snap: true,
      floating: true,
      expandedHeight: 250.0,
      leadingWidth: 75.0,
      leading: leading,
      flexibleSpace: FlexibleSpaceBar(title: Text('')),
      actions: actions,
      actionsPadding: EdgeInsets.only(right: 20.0),
    );
  }
}
