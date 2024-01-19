import 'package:flutter/material.dart';

class QuranNotesTextFieldWidget extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final TextEditingController textEditingController;

  const QuranNotesTextFieldWidget({
    Key? key,
    required this.title,
    required this.isEnabled,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          10,
          10,
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                0,
                10,
                0,
              ),
              child: Text(
                title,
                style: const TextStyle(color: Colors.black54),
              ),
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
          ],
        ),
      ),
    );
  }
}
