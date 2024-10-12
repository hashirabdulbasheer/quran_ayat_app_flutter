import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollableListWidget extends StatefulWidget {
  final int itemsCount;
  final int? initialIndex;
  final Widget Function(int) itemContent;
  final Function(bool) onTopReached;

  const ScrollableListWidget({
    super.key,
    this.initialIndex,
    required this.onTopReached,
    required this.itemContent,
    required this.itemsCount,
  });

  @override
  State<ScrollableListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ScrollableListWidget> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_scrollPositionListener);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions
        .removeListener(_scrollPositionListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToAyat());
    return _body();
  }

  Widget _body() {
    return ScrollablePositionedList.separated(
      itemScrollController: _itemScrollController,
      initialScrollIndex: 0,
      itemCount: widget.itemsCount,
      itemPositionsListener: _itemPositionsListener,
      itemBuilder: (context, index) => widget.itemContent(index),
      separatorBuilder: (context, index) => const Divider(thickness: 1),
    );
  }

  void _scrollToAyat() {
    _itemScrollController.jumpTo(index: widget.initialIndex ?? 0);
  }

  void _scrollPositionListener() {
    if (_itemPositionsListener.itemPositions.value.first.index <= 0) {
      widget.onTopReached(true);
    } else {
      widget.onTopReached(false);
    }
  }
}
