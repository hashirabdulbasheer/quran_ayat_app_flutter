import 'package:flutter/material.dart';

class QuranReloadButtonWidget extends StatefulWidget {
  final Function action;

  const QuranReloadButtonWidget({
    super.key,
    required this.action,
  });

  @override
  State<QuranReloadButtonWidget> createState() =>
      _QuranReloadButtonWidgetState();
}

class _QuranReloadButtonWidgetState extends State<QuranReloadButtonWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_isLoading)
          const Center(
            heightFactor: 1,
            widthFactor: 1,
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ),

        /// place holder icon button for size
        IconButton(
          onPressed: () => _reloadAction(),
          icon: Icon(
            Icons.refresh_rounded,
            color: _isLoading ? Colors.transparent : Colors.white,
          ),
        ),
      ],
    );
  }

  void _reloadAction() {
    setState(() {
      _isLoading = true;
    });
    widget.action();
    Future<void>.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        _isLoading = false;
      }),
    );
  }
}
