import 'package:ayat_app/src/presentation/home/home.dart';

class BoxedText extends StatelessWidget {
  final String text;
  final double textScaleFactor;

  const BoxedText({
    super.key,
    required this.text,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
            BorderSide(color: Theme.of(context).disabledColor)),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Theme.of(context).disabledColor),
        textScaler: TextScaler.linear(textScaleFactor),
      ),
    );
  }
}
