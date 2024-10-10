import 'package:ayat_app/src/presentation/home/home.dart';

extension HomeBlocUtils on HomeBloc {
  Future<double> increaseTextSize() async {
    double currentScale = fetchFontScaleUseCase.call();
    if (currentScale < kFontScaleFactor * 10) {
      currentScale = currentScale + kFontScaleFactor;
    }
    await setFontScaleUseCase.call(SetFontScaleParams(fontScale: currentScale));
    return currentScale;
  }

  Future<double> decreaseTextSize() async {
    double currentScale = fetchFontScaleUseCase.call();
    if (currentScale > kFontScaleFactor * 2) {
      currentScale = currentScale - kFontScaleFactor;
    }
    await setFontScaleUseCase.call(SetFontScaleParams(fontScale: currentScale));
    return currentScale;
  }

  Future<double> resetTextSize() async {
    double currentScale = 1;
    await setFontScaleUseCase.call(SetFontScaleParams(fontScale: currentScale));
    return currentScale;
  }
}
