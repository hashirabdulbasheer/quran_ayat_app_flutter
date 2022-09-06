import 'package:flutter/material.dart';

import '../../domain/notes_manager.dart';

class QuranOfflineHeaderWidget extends StatelessWidget {
  const QuranOfflineHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: QuranNotesManager.instance.isOffline(),
      // async work
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError) {
              return Container();
            } else {
              bool isOffline = snapshot.data as bool;
              if (isOffline) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(color: Colors.black12),
                          ),
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: const Text(
                          "OFFLINE",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Container();
            }
        }
      },
    );
  }
}
