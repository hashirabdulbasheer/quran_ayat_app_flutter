import 'package:ayat_app/main.dart';
import 'package:ayat_app/src/core/extensions/widget_spacer_extension.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/presentation/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return StreamBuilder<QPageData>(
        stream: context.read<HomeBloc>().currentPageData$,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              bottom: true,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  5,
                  10,
                  5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(appVersion, style: TextStyle(fontSize: 10)),
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
                  ],
                ),
              ),
            ),
          );
        });
  }
}
