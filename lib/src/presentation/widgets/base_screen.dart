import 'package:ayat_app/src/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class QBaseScreen extends StatelessWidget {
  final List<Widget> navBarActions;

  const QBaseScreen({
    super.key,
    required this.child,
    this.navBarActions = const [],
    this.bottomSheet,
    this.title,
  });

  final String? title;
  final Widget child;
  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(actions: navBarActions, title: title),
      bottomSheet: bottomSheet,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
