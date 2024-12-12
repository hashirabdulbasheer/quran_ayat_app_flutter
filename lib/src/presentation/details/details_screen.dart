import 'package:ayat_app/src/presentation/home/home.dart';

class DetailsScreen extends StatelessWidget {
  final SurahIndex index;

  const DetailsScreen({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return QBaseScreen(
      title: "${index.human.sura}:${index.human.aya}",
      child: SafeArea(
          child: StreamBuilder<QPageData>(
              stream: context.read<HomeBloc>().currentPageData$,
              builder: (context, snapshot) {
                QPageData? pageData = snapshot.data;
                if (pageData == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return AyaDataTileWidget(
                  pageData: pageData,
                  index: index,
                  isDetailed: true,
                );
              })),
    );
  }
}
