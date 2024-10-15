import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollableListWidget extends StatefulWidget {
  final int itemsCount;
  final int? initialIndex;
  final Widget Function(int) itemContent;

  const ScrollableListWidget({
    super.key,
    this.initialIndex,
    required this.itemContent,
    required this.itemsCount,
  });

  @override
  State<ScrollableListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ScrollableListWidget> {
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ScrollableListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(const Duration(milliseconds: 500), () {
      _itemScrollController.jumpTo(index: widget.initialIndex ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return ScrollablePositionedList.separated(
      itemScrollController: _itemScrollController,
      initialScrollIndex: 0,
      itemCount: widget.itemsCount,
      itemBuilder: (context, index) => widget.itemContent(index),
      separatorBuilder: (context, index) => const Divider(thickness: 1),
    );
  }
}
