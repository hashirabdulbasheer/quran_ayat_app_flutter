import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListWidget extends StatefulWidget {
  final int itemsCount;
  final int? initialIndex;
  final Widget Function(
    int,
  ) itemContent;

  const ListWidget({
    super.key,
    this.initialIndex,
    required this.itemContent,
    required this.itemsCount,
  });

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToAyat());
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return ScrollablePositionedList.separated(
      itemScrollController: _itemScrollController,
      itemCount: widget.itemsCount,
      itemBuilder: (
        context,
        index,
      ) =>
          widget.itemContent(
        index,
      ),
      separatorBuilder: (
        context,
        index,
      ) =>
          const Divider(
        thickness: 0.2,
      ),
    );
  }

  void _scrollToAyat() {
    _itemScrollController.jumpTo(index: widget.initialIndex ?? 0);
  }
}
