import 'package:flutter/material.dart';

import '../../quran_textfield_full_sheet.dart';
import 'quran_note_entry_textfield_widget.dart';

class QuranTappableSmallTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;

  const QuranTappableSmallTextFieldWidget({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet<bool>(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          elevation: 5,
          builder: (context) => QuranFullTextFieldBottomSheet(
            title: "Enter Note",
            controller: controller,
          ),
        ),
      },
      child: SizedBox(
        height: 250,
        child: QuranNotesTextFieldWidget(
          title: title,
          hint: title,
          textEditingController: controller,
          isEnabled: false,
        ),
      ),
    );
  }
}
