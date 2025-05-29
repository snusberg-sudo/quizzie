import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.collapsedHeight = 85.0,
    this.expandedHeight = 250.0,
    this.flexibleSpace,
    this.automaticallyImplyLeading = true,
    this.backgroundColor = Colors.indigoAccent
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle, automaticallyImplyLeading;
  final double expandedHeight, collapsedHeight;
  final Widget? flexibleSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
        side: BorderSide(color: Colors.black87, width: 1.5)
      ),
      backgroundColor: backgroundColor,
      title: title,
      pinned: true,
      floating: false,
      snap: false,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
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
