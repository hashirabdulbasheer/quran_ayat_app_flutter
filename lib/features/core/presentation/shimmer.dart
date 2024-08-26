import 'package:flutter/material.dart';

class QuranShimmer extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const QuranShimmer({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return const SizedBox(
      width: 30,
      height: 30,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: CircularProgressIndicator(
          color: Colors.white60,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
