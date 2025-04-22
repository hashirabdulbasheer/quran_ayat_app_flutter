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
    this.onTitleTapped,
  });

  final String? title;
  final Widget child;
  final Widget? bottomSheet;
  final VoidCallback? onTitleTapped;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(
        actions: navBarActions,
        title: title,
        onTitlePressed: onTitleTapped,
      ),
      bottomSheet: bottomSheet,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: MediaQuery.of(context).size.width >= 1000
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: child))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
