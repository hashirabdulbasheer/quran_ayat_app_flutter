import 'package:flutter/material.dart';

class QuranNavDrawerRowWidget extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final Widget destination;

  const QuranNavDrawerRowWidget({
    Key? key,
    required this.context,
    required this.title,
    required this.icon,
    required this.destination,
  }) : super(key: key);

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
        Navigator.push<void>(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ),
      },
    );
  }
}
