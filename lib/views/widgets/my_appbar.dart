import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({
    super.key,
    required this.title,
    required this.leading,
    required this.actions,
    this.centerTitle = false,
    this.expandedHeight = 250.0,
    this.flexibleSpace,
    this.automaticallyImplyLeading = true,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle, automaticallyImplyLeading;
  final double expandedHeight;
  final Widget? flexibleSpace;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22.0)),
      ),
      backgroundColor: Color(
        0xff7e80d8,
      ), //Colors.blueAccent.shade400.withValues(alpha: 0.6),
      title: title,
      pinned: true,
      floating: false,
      snap: false,
      expandedHeight: expandedHeight,
      collapsedHeight: 85.0,
      leadingWidth: 75.0,
      leading: leading,
      flexibleSpace: flexibleSpace,
      actions: actions,
      actionsPadding: EdgeInsets.only(right: 20.0),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
