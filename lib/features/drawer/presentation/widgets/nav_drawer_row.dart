import 'package:flutter/material.dart';

import '../../../../utils/logger_utils.dart';

class QuranNavDrawerRowWidget extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final Widget? destination;
  final Function? onSelected;

  const QuranNavDrawerRowWidget({
    super.key,
    required this.context,
    required this.title,
    required this.icon,
    this.destination,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () => {
        Navigator.of(context).pop(),
        _onTapped(),
        QuranLogger.logAnalyticsWithParams(
          "menu-drawer-selected",
          {'item': title},
        ),
      },
    );
  }

  void _onTapped() {
    if (destination != null) {
      Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (context) => destination!),
      );
    } else {
      if (onSelected != null) {
        onSelected!();
      }
    }
  }
}
