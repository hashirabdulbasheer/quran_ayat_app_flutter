import 'package:flutter/material.dart';

class QuranNavDrawerItemsWidget extends StatelessWidget {
  final List<Widget> items;

  const QuranNavDrawerItemsWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          separatorBuilder: (
            context,
            index,
          ) {
            if (index > 0) {
              return const Divider(thickness: 0.1);
            }

            return Container();
          },
          padding: EdgeInsets.zero,
          itemBuilder: (
            context,
            index,
          ) {
            return items[index];
          },
          itemCount: items.length,
        ),
      ],
    );
  }
}
