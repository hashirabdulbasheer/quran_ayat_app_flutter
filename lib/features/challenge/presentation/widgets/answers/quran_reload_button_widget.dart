import 'package:flutter/material.dart';

class QuranReloadButtonWidget extends StatefulWidget {
  final Function action;

  const QuranReloadButtonWidget({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  State<QuranReloadButtonWidget> createState() =>
      _QuranReloadButtonWidgetState();
}

class _QuranReloadButtonWidgetState extends State<QuranReloadButtonWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Center(
              heightFactor: 1,
              widthFactor: 1,
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          )
        : IconButton(
            onPressed: () => _reloadAction(),
            icon: const Icon(
              Icons.refresh_rounded,
            ),
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
