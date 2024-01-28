import 'package:flutter/material.dart';

class QuranNotesTextFieldWidget extends StatelessWidget {
  final String title;
  final String hint;
  final bool isEnabled;
  final TextEditingController textEditingController;

  const QuranNotesTextFieldWidget({
    Key? key,
    required this.title,
    required this.hint,
    required this.isEnabled,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'fullScreenTextField',
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: TextField(
                  enabled: isEnabled,
                  controller: textEditingController..text,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 20,
                  style: TextStyle(
                    color: !isEnabled ? Colors.black : null,
                  ),

                  autofocus: true,
                  canRequestFocus: true,
                  enableInteractiveSelection: true,
                  decoration: InputDecoration(
                    hintText: hint,
                    labelText: title,
                    helperText: "",
                    hintStyle: const TextStyle(
                      height: 2.0, // sets the distance between label and input
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
