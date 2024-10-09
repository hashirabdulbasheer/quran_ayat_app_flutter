import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TextSizeAdjuster extends StatelessWidget {
  final BehaviorSubject<double> settings$;

  final Widget Function(BuildContext, double) child;

  const TextSizeAdjuster({
    super.key,
    required this.settings$,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: settings$,
        builder: (context, snapshot) {
          double textScaleFactor = 1;
          if (!snapshot.hasError && snapshot.data != null) {
            textScaleFactor = snapshot.data as double;
          }

          return child(context, textScaleFactor);
        });
  }
}
