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
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex ?? 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToAyat());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Stack(
      children: [
        ScrollablePositionedList.separated(
          itemScrollController: _itemScrollController,
          initialScrollIndex: 0,
          itemCount: widget.itemsCount,
          itemBuilder: (context, index) => widget.itemContent(index),
          separatorBuilder: (context, index) => const Divider(thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _NextAyaWidget(onNext: () {
            if (currentIndex < widget.itemsCount - 1) {
              currentIndex += 1;
              _itemScrollController.scrollTo(
                index: currentIndex,
                duration: const Duration(milliseconds: 200),
              );
            }
          }),
        )
      ],
    );
  }

  void _scrollToAyat() {
    _itemScrollController.jumpTo(index: widget.initialIndex ?? 0);
  }
}

class _NextAyaWidget extends StatelessWidget {
  final VoidCallback onNext;

  const _NextAyaWidget({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: FloatingActionButton.small(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: onNext,
          child: const Icon(Icons.arrow_drop_down)),
    );
  }
}
