import 'package:ayat_app/src/presentation/home/home.dart';

class AyaControlWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarked;
  final VoidCallback onMore;
  final VoidCallback onCopy;
  final VoidCallback onScreenshot;

  const AyaControlWidget({
    super.key,
    required this.isBookmarked,
    required this.onBookmarked,
    required this.onMore,
    required this.onCopy,
    required this.onScreenshot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: onMore,
            icon: Icon(
              Icons.more_outlined,
              color: Theme.of(context).disabledColor,
            )),
        IconButton(
            onPressed: onCopy,
            icon: Icon(
              Icons.copy,
              color: Theme.of(context).disabledColor,
            )),
        IconButton(
            onPressed: onScreenshot,
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Theme.of(context).disabledColor,
            )),
        IconButton(
          onPressed: onBookmarked,
          icon: isBookmarked
              ? Icon(
                  Icons.bookmark_added,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.bookmark_add_outlined,
                  color: Theme.of(context).disabledColor,
                ),
        ),
      ],
    );
  }
}
