import 'package:flutter/material.dart';

class QuranSmallTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const QuranSmallTextFieldWidget({
    Key? key,
    required this.controller,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<QuranSmallTextFieldWidget> createState() =>
      _QuranSmallTextFieldWidgetState();
}

class _QuranSmallTextFieldWidgetState extends State<QuranSmallTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "asd",
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Hero(
            tag: 'fullScreenTextField',
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    style: TextStyle(
                      color: !widget.isEnabled ? Colors.black : null,
                    ),
                    enabled: widget.isEnabled,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 20,
                    autofocus: true,
                    canRequestFocus: true,
                    controller: widget.controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
