import 'package:flutter/material.dart';

class QuranNavDrawerItemsWidget extends StatelessWidget {
  final List<Widget> items;

  const QuranNavDrawerItemsWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (
        context,
        index,
      ) {
        if (index > 0) {
          return const Divider(thickness: 1);
        }

        return const Divider();
      },
      padding: EdgeInsets.zero,
      itemBuilder: (
        context,
        index,
      ) {
        return items[index];
      },
      itemCount: items.length,
    );
  }
}
