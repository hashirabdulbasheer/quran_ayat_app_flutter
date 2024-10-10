import 'package:ayat_app/src/presentation/home/home.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (context, index) {
              const arabic = _ShimmerWidget(width: 100, height: 80);
              const english = _ShimmerWidget(width: 100, height: 30);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // runAlignment: WrapAlignment.start,
                      // crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Column(
                            children: [arabic, english]
                                .spacerDirectional(height: 10)),
                        Column(
                            children: [arabic, english]
                                .spacerDirectional(height: 10)),
                        Column(
                            children: [arabic, english]
                                .spacerDirectional(height: 10)),
                      ].spacerDirectional(width: 10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _ShimmerWidget(width: 600, height: 30),
                  const SizedBox(height: 30)
                ].spacerDirectional(height: 10),
              );
            }),
      ),
    );
  }
}

class _ShimmerWidget extends StatelessWidget {
  final num width;
  final num height;

  const _ShimmerWidget({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.rtl,
        baseColor: _baseColor(context),
        highlightColor: _highlightColor(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xffEBEBEB),
          ),
        ),
      ),
    );
  }

  Color _baseColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(0xFF, 0x33, 0x33, 0x33)
        : Colors.grey.shade100;
  }

  Color _highlightColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(0xFF, 0x66, 0x66, 0x66)
        : Colors.grey.shade300;
  }
}
