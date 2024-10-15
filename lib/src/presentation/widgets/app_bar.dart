import 'package:flutter/material.dart';

class QAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QAppBar({
    super.key,
    this.forceMaterialTransparency = true,
    this.actions,
    this.title,
  });

  final bool forceMaterialTransparency;
  final List<Widget>? actions;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      foregroundColor: Theme.of(context).primaryColor,
      title: Text(
        title ?? '',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      forceMaterialTransparency: forceMaterialTransparency,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}
