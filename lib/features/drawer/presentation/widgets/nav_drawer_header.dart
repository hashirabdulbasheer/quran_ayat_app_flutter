import 'package:flutter/material.dart';

import '../../../../main.dart';

class QuranNavDrawerHeaderWidget extends StatelessWidget {
  const QuranNavDrawerHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: const Text(
          "$appVersion uxQuran",
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
