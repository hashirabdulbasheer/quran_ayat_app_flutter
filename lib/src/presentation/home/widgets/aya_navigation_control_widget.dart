import 'package:ayat_app/src/presentation/home/home.dart';

class AyaNavigationControl extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AyaNavigationControl({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QPageData>(
        stream: context.read<HomeBloc>().currentPageData$,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              bottom: true,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  5,
                  10,
                  5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: onBack,
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: onNext,
                              child: const Text(
                                "Next",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ].spacerDirectional(width: 10),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Text(kAppVersion, style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
