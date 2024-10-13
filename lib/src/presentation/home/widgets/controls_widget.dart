import 'package:ayat_app/src/presentation/home/home.dart';

class DisplayControls extends StatelessWidget {
  final VoidCallback onContextPressed;
  final VoidCallback onTextSizeIncreasePressed;
  final VoidCallback onTextSizeDecreasePressed;
  final VoidCallback onTextSizeResetPressed;

  const DisplayControls({
    super.key,
    required this.onContextPressed,
    required this.onTextSizeIncreasePressed,
    required this.onTextSizeDecreasePressed,
    required this.onTextSizeResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          tooltip: "Increase font size",
          onPressed: onTextSizeIncreasePressed,
          icon: const Icon(Icons.add, size: 15),
        ),
        IconButton(
          tooltip: "Decrease font size",
          onPressed: onTextSizeDecreasePressed,
          icon: const Icon(Icons.remove, size: 15),
        ),
        IconButton(
          tooltip: "Reset font size",
          onPressed: onTextSizeResetPressed,
          icon: const Icon(Icons.refresh, size: 15),
        ),
        const Spacer()
      ],
    );
  }
}
