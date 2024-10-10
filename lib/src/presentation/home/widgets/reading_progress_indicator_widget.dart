import 'package:ayat_app/src/presentation/home/home.dart';

class ReadingProgressIndicator extends StatelessWidget {
  final double progress;

  const ReadingProgressIndicator({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: LinearProgressIndicator(
        value: progress,
      ),
    );
  }
}
