import 'package:flutter/material.dart';

class RefreshableFallback extends StatelessWidget {
  const RefreshableFallback({super.key, required this.onRefresh, required this.text});

  final RefreshCallback onRefresh;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          primary: false,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(child: Text(text)),
            ),
          ],
        ),
      );;
  }
}