import 'package:ayat_app/src/presentation/home/home.dart';

class AyaControlWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarked;
  final VoidCallback onMore;

  const AyaControlWidget({
    super.key,
    required this.isBookmarked,
    required this.onBookmarked,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onMore, icon: const Icon(Icons.more_outlined)),
        IconButton(
          onPressed: onBookmarked,
          icon: isBookmarked
              ? Icon(
                  Icons.bookmark,
                  color: Theme.of(context).primaryColor,
                )
              : const Icon(Icons.bookmark_border),
        ),
      ],
    );
  }
}
