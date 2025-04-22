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
      title: "",
      child: SafeArea(
        child: StreamBuilder<QPageData>(
          stream: context.read<HomeBloc>().currentPageData$,
          builder: (context, snapshot) {
            QPageData? pageData = snapshot.data;
            if (pageData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: AyaDataTileWidget(
                          pageData: pageData,
                          index: index,
                          isDetailed: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
