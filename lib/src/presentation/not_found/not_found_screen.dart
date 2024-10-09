import 'package:ayat_app/src/presentation/widgets/base_screen.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const QBaseScreen(child: Text("Page Not Found"));
  }
}
