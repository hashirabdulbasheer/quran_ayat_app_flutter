import 'package:ayat_app/src/presentation/home/home.dart';

class AyaControlWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarked;
  final VoidCallback onMore;
  final VoidCallback onCopy;

  const AyaControlWidget({
    super.key,
    required this.isBookmarked,
    required this.onBookmarked,
    required this.onMore,
    required this.onCopy,
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
          onPressed: onBookmarked,
          icon: isBookmarked
              ? Icon(
                  Icons.bookmark,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.bookmark_border,
                  color: Theme.of(context).disabledColor,
                ),
        ),
      ],
    );
  }
}
