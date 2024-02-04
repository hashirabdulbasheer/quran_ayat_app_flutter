// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_ayat/misc/constants/string_constants.dart';

void main() {

  testWidgets('is_arabic_test', (WidgetTester tester) async {
    // String input = "الحمد لله";
    // bool isArabic = QuranUtils.isArabic(input);
    // expect(isArabic, true,);
    //
    // input = "Alhamdulillah";
    // isArabic = QuranUtils.isArabic(input);
    // expect(isArabic, false,);
    //
    // input = "Alhamdulillah الحمدلله";
    // isArabic = QuranUtils.isArabic(input);
    // expect(isArabic, true,);
    //
    // input = "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ";
    // isArabic = QuranUtils.isArabic(input);
    // expect(isArabic, true,);

    final alphanumeric = RegExp(QuranStrings.urlParamsNewFormatRegEx);
    bool isMatch = alphanumeric.hasMatch("/");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("123");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18");
    expect(isMatch, true,);
    isMatch = alphanumeric.hasMatch("/abc");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/@#@#");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18asds");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18/");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18/100");
    expect(isMatch, true,);
    isMatch = alphanumeric.hasMatch("/18/aaa100");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18/100/");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18asds/100");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18/100/18");
    expect(isMatch, false,);
    isMatch = alphanumeric.hasMatch("/18/100/18/10");
    expect(isMatch, false,);

  },);
}
