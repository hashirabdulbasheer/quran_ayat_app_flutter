import 'package:ayat_app/main.dart';
import 'package:ayat_app/src/core/extensions/widget_spacer_extension.dart';
import 'package:flutter/material.dart';

class AyaNavigationControl extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const AyaNavigationControl({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        bottom: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            10,
            10,
            10,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.start,
                      icon: const Icon(Icons.navigate_before, size: 20),
                      label: const Text(
                        "Back",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: onPrevious,
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.navigate_next, size: 20),
                      label: const Text(
                        "Next",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: onNext,
                    ),
                  ),
                ].spacerDirectional(width: 10),
              ),
              const Text(appVersion, style: TextStyle(fontSize: 10),)
            ].spacerDirectional(height: 10),
          ),
        ),
      ),
    );
  }
}
