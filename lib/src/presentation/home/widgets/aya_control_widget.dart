import 'package:ayat_app/src/presentation/home/home.dart';

class AyaControlWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarked;
  final VoidCallback onMore;
  final VoidCallback onCopy;
  final VoidCallback onScreenshot;
  final VoidCallback onDriveModePressed;

  const AyaControlWidget({
    super.key,
    required this.isBookmarked,
    required this.onBookmarked,
    required this.onMore,
    required this.onCopy,
    required this.onScreenshot,
    required this.onDriveModePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            tooltip: "Navigate to the old app with this verse",
            onPressed: onMore,
            icon: Icon(
              Icons.more_outlined,
              size: 18,
              color: Theme.of(context).disabledColor,
            )),
        IconButton(
            tooltip: "Copy this verse",
            onPressed: onCopy,
            icon: Icon(
              Icons.copy,
              size: 18,
              color: Theme.of(context).disabledColor,
            )),
        IconButton(
            tooltip: "Save the verse as an photo",
            onPressed: onScreenshot,
            icon: Icon(
              Icons.camera_alt_outlined,
              size: 18,
              color: Theme.of(context).disabledColor,
            )),
        IconButton(
          tooltip: "Bookmark this verse",
          onPressed: onBookmarked,
          icon: isBookmarked
              ? Icon(
                  Icons.bookmark_added,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.bookmark_add_outlined,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
        ),
        IconButton(
          tooltip: "Drive mode",
          onPressed: onDriveModePressed,
          icon: Icon(
            Icons.drive_eta_outlined,
            size: 20,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ],
    );
  }
}
