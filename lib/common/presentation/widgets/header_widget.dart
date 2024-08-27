import 'package:flutter/material.dart';

class QuranHeaderWidget extends StatelessWidget {
  final Widget child;

  const QuranHeaderWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: Colors.black12),
        ),
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.fromLTRB(
        10,
        0,
        10,
        0,
      ),
      child: child,
    );
  }
}
