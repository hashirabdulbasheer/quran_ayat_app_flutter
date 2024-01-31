import 'package:flutter/material.dart';

import '../../../misc/design/design_system.dart';
import 'widgets/create/quran_note_entry_textfield_widget.dart';

class QuranFullTextFieldScreen extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const QuranFullTextFieldScreen({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  },
                  child: const Text(
                    "Save",
                    style: QuranDS.textTitleLargeBold,
                  ),
                ),
                Text(
                  title,
                  style: QuranDS.textTitleLargeBold,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 30,
              child: QuranNotesTextFieldWidget(
                textEditingController: controller,
                hint: "Start writing...",
                title: "",
                isEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
