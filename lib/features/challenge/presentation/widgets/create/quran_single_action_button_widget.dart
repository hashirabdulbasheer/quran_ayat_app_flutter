import 'package:flutter/material.dart';

class QuranSingleActionButtonWidget extends StatelessWidget {
  final bool? isLoading;
  final String buttonText;
  final Function onPressed;

  const QuranSingleActionButtonWidget({
    Key? key,
    required this.buttonText,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => onPressed(),
              child: isLoading == true
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(buttonText),
            ),
          ),
        ),
      ],
    );
  }
}
