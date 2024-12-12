import 'package:ayat_app/src/presentation/home/home.dart';

class DetailsScreen extends StatelessWidget {
  final SurahIndex index;

  const DetailsScreen({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    QPageData? pageData = context.read<HomeBloc>().currentPageData$.hasValue
        ? context.read<HomeBloc>().currentPageData$.value
        : null;

    return QBaseScreen(
      title: "${index.human.sura}:${index.human.aya}",
      child: SafeArea(child: Text(pageData?.translations[0].$2[index.aya].text ?? "n/a")),
    );
  }
}
