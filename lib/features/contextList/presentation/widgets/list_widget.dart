import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../ayats/presentation/widgets/font_scaler_widget.dart';

class ListWidget extends StatefulWidget {
  final int itemsCount;
  final int? initialAyaIndex;
  final Widget Function(int,) itemContent;

  const ListWidget({
    Key? key,
    this.initialAyaIndex,
    required this.itemContent,
    required this.itemsCount,
  }) : super(key: key);

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToAyat());
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return ScrollablePositionedList.separated(
        itemScrollController: _itemScrollController,
        itemCount: widget.itemsCount,
        itemBuilder: (context, index,) => widget.itemContent(index,),
        separatorBuilder: (context, index,) => const Divider(thickness: 0.2,),);
  }

  void _scrollToAyat() {
    _itemScrollController.jumpTo(index: widget.initialAyaIndex ?? 0);
  }

}
