import 'package:flutter/material.dart';
import 'dart:ui';

class QuranNavDrawerItemsWidget extends StatelessWidget {
  final List<Widget> items;

  const QuranNavDrawerItemsWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0,),
            child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),),
            ),
        ),
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
