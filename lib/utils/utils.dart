import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:uuid/uuid.dart';

import '../features/settings/domain/settings_manager.dart';
import '../misc/enums/quran_status_enum.dart';
import '../models/qr_word_model.dart';

import 'package:intl/intl.dart' as intl;

class QuranUtils {
  static void showMessage(
    BuildContext context,
    String? message,
  ) {
    if (message != null && message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(message),
        ),
      ));
    }
  }

  static Future<bool> isOffline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.bluetooth ||
        connectivityResult == ConnectivityResult.ethernet) {
      return false;
    }

    return true;
  }

  static String getAudioUrl(
    String baseAudioUrl,
    String reciter,
    int surahIndex,
    int ayaIndex,
  ) {
    final intl.NumberFormat formatter = intl.NumberFormat("000");

    return "$baseAudioUrl/$reciter/${formatter.format(surahIndex)}${formatter.format(ayaIndex)}.mp3";
  }

  static Future<String> shareString(
    String surahName,
    int surah,
    int aya,
  ) async {
    int actualSuraIndex = surah - 1;
    int actualAyaIndex = aya - 1;
    NQSurah arabicSurah = await NobleQuran.getSurahArabic(actualSuraIndex);
    NQTranslation translation =
        await QuranSettingsManager.instance.getTranslation();
    NQSurah translationSurah = await NobleQuran.getTranslationString(
      actualSuraIndex,
      translation,
    );
    StringBuffer response = StringBuffer();
    response.write("Sura $surahName - $surah:$aya\n\n");
    response.write("${arabicSurah.aya[actualAyaIndex].text}\n\n");
    response.write("${translationSurah.aya[actualAyaIndex].text}\n\n");
    response.write(
      "More details:\nhttp://uxquran.com/apps/quran-ayat/?sura=$surah&aya=$aya\n",
    );

    return response.toString();
  }

  static QuranStatusEnum statusFromString(String value) {
    if (value.toLowerCase() == "created") {
      return QuranStatusEnum.created;
    } else if (value.toLowerCase() == "updated") {
      return QuranStatusEnum.updated;
    } else if (value.toLowerCase() == "deleted") {
      return QuranStatusEnum.deleted;
    }

    return QuranStatusEnum.created;
  }

  static String uniqueId() {
    return const Uuid().v1();
  }

  static bool isEmail(String e) {
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(e);

    return emailValid;
  }

  static bool isArabic(String s) {
    RegExp regex = RegExp(
      "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]",
    );

    return regex.hasMatch(s);
  }

  static bool isMalayalam(String s) {
    RegExp regex = RegExp("[\u0D15-\u0D39]|[\u0D02-\u0D57]|[\u0D66-\u0D6F]");

    return regex.hasMatch(s);
  }

  static bool isEnglish(String s) {
    RegExp regex = RegExp("[a-zA-Z0-9]+");

    return regex.hasMatch(s);
  }

  static String replaceFarsiNumber(String input) {
    var sb = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      switch (input[i]) {
        //Persian digits
        case '\u06f0':
          sb.write('0');
          break;
        case '\u06f1':
          sb.write('1');
          break;
        case '\u06f2':
          sb.write('2');
          break;
        case '\u06f3':
          sb.write('3');
          break;
        case '\u06f4':
          sb.write('4');
          break;
        case '\u06f5':
          sb.write('5');
          break;
        case '\u06f6':
          sb.write('6');
          break;
        case '\u06f7':
          sb.write('7');
          break;
        case '\u06f8':
          sb.write('8');
          break;
        case '\u06f9':
          sb.write('9');
          break;

        //Arabic digits
        case '\u0660':
          sb.write('0');
          break;
        case '\u0661':
          sb.write('1');
          break;
        case '\u0662':
          sb.write('2');
          break;
        case '\u0663':
          sb.write('3');
          break;
        case '\u0664':
          sb.write('4');
          break;
        case '\u0665':
          sb.write('5');
          break;
        case '\u0666':
          sb.write('6');
          break;
        case '\u0667':
          sb.write('7');
          break;
        case '\u0668':
          sb.write('8');
          break;
        case '\u0669':
          sb.write('9');
          break;
        default:
          sb.write(input[i]);
          break;
      }
    }

    return sb.toString();
  }

  /// removes duplicates
  static List<QuranWord> removeDuplicates(List<QuranWord> words) {
    List<QuranWord> result = [];
    result.addAll(words.where((a) =>
        result.every((b) => normalise(a.word.ar) != normalise(b.word.ar))));

    return result;
  }

  /// removes vowel signs
  static String normalise(String input) => input
      .replaceAll(
        '\u0610',
        '',
      ) //ARABIC SIGN SALLALLAHOU ALAYHE WA SALLAM
      .replaceAll(
        '\u0611',
        '',
      ) //ARABIC SIGN ALAYHE ASSALLAM
      .replaceAll(
        '\u0612',
        '',
      ) //ARABIC SIGN RAHMATULLAH ALAYHE
      .replaceAll(
        '\u0613',
        '',
      ) //ARABIC SIGN RADI ALLAHOU ANHU
      .replaceAll(
        '\u0614',
        '',
      ) //ARABIC SIGN TAKHALLUS

      //Remove koranic anotation
      .replaceAll(
        '\u0615',
        '',
      ) //ARABIC SMALL HIGH TAH
      .replaceAll(
        '\u0616',
        '',
      ) //ARABIC SMALL HIGH LIGATURE ALEF WITH LAM WITH YEH
      .replaceAll(
        '\u0617',
        '',
      ) //ARABIC SMALL HIGH ZAIN
      .replaceAll(
        '\u0618',
        '',
      ) //ARABIC SMALL FATHA
      .replaceAll(
        '\u0619',
        '',
      ) //ARABIC SMALL DAMMA
      .replaceAll(
        '\u061A',
        '',
      ) //ARABIC SMALL KASRA
      .replaceAll(
        '\u06D6',
        '',
      ) //ARABIC SMALL HIGH LIGATURE SAD WITH LAM WITH ALEF MAKSURA
      .replaceAll(
        '\u06D7',
        '',
      ) //ARABIC SMALL HIGH LIGATURE QAF WITH LAM WITH ALEF MAKSURA
      .replaceAll(
        '\u06D8',
        '',
      ) //ARABIC SMALL HIGH MEEM INITIAL FORM
      .replaceAll(
        '\u06D9',
        '',
      ) //ARABIC SMALL HIGH LAM ALEF
      .replaceAll(
        '\u06DA',
        '',
      ) //ARABIC SMALL HIGH JEEM
      .replaceAll(
        '\u06DB',
        '',
      ) //ARABIC SMALL HIGH THREE DOTS
      .replaceAll(
        '\u06DC',
        '',
      ) //ARABIC SMALL HIGH SEEN
      .replaceAll(
        '\u06DD',
        '',
      ) //ARABIC END OF AYAH
      .replaceAll(
        '\u06DE',
        '',
      ) //ARABIC START OF RUB EL HIZB
      .replaceAll(
        '\u06DF',
        '',
      ) //ARABIC SMALL HIGH ROUNDED ZERO
      .replaceAll(
        '\u06E0',
        '',
      ) //ARABIC SMALL HIGH UPRIGHT RECTANGULAR ZERO
      .replaceAll(
        '\u06E1',
        '',
      ) //ARABIC SMALL HIGH DOTLESS HEAD OF KHAH
      .replaceAll(
        '\u06E2',
        '',
      ) //ARABIC SMALL HIGH MEEM ISOLATED FORM
      .replaceAll(
        '\u06E3',
        '',
      ) //ARABIC SMALL LOW SEEN
      .replaceAll(
        '\u06E4',
        '',
      ) //ARABIC SMALL HIGH MADDA
      .replaceAll(
        '\u06E5',
        '',
      ) //ARABIC SMALL WAW
      .replaceAll(
        '\u06E6',
        '',
      ) //ARABIC SMALL YEH
      .replaceAll(
        '\u06E7',
        '',
      ) //ARABIC SMALL HIGH YEH
      .replaceAll(
        '\u06E8',
        '',
      ) //ARABIC SMALL HIGH NOON
      .replaceAll(
        '\u06E9',
        '',
      ) //ARABIC PLACE OF SAJDAH
      .replaceAll(
        '\u06EA',
        '',
      ) //ARABIC EMPTY CENTRE LOW STOP
      .replaceAll(
        '\u06EB',
        '',
      ) //ARABIC EMPTY CENTRE HIGH STOP
      .replaceAll(
        '\u06EC',
        '',
      ) //ARABIC ROUNDED HIGH STOP WITH FILLED CENTRE
      .replaceAll(
        '\u06ED',
        '',
      ) //ARABIC SMALL LOW MEEM

      //Remove tatweel
      .replaceAll(
        '\u0640',
        '',
      )

      //Remove tashkeel
      .replaceAll(
        '\u064B',
        '',
      ) //ARABIC FATHATAN
      .replaceAll(
        '\u064C',
        '',
      ) //ARABIC DAMMATAN
      .replaceAll(
        '\u064D',
        '',
      ) //ARABIC KASRATAN
      .replaceAll(
        '\u064E',
        '',
      ) //ARABIC FATHA
      .replaceAll(
        '\u064F',
        '',
      ) //ARABIC DAMMA
      .replaceAll(
        '\u0650',
        '',
      ) //ARABIC KASRA
      .replaceAll(
        '\u0651',
        '',
      ) //ARABIC SHADDA
      .replaceAll(
        '\u0652',
        '',
      ) //ARABIC SUKUN
      .replaceAll(
        '\u0653',
        '',
      ) //ARABIC MADDAH ABOVE
      .replaceAll(
        '\u0654',
        '',
      ) //ARABIC HAMZA ABOVE
      .replaceAll(
        '\u0655',
        '',
      ) //ARABIC HAMZA BELOW
      .replaceAll(
        '\u0656',
        '',
      ) //ARABIC SUBSCRIPT ALEF
      .replaceAll(
        '\u0657',
        '',
      ) //ARABIC INVERTED DAMMA
      .replaceAll(
        '\u0658',
        '',
      ) //ARABIC MARK NOON GHUNNA
      .replaceAll(
        '\u0659',
        '',
      ) //ARABIC ZWARAKAY
      .replaceAll(
        '\u065A',
        '',
      ) //ARABIC VOWEL SIGN SMALL V ABOVE
      .replaceAll(
        '\u065B',
        '',
      ) //ARABIC VOWEL SIGN INVERTED SMALL V ABOVE
      .replaceAll(
        '\u065C',
        '',
      ) //ARABIC VOWEL SIGN DOT BELOW
      .replaceAll(
        '\u065D',
        '',
      ) //ARABIC REVERSED DAMMA
      .replaceAll(
        '\u065E',
        '',
      ) //ARABIC FATHA WITH TWO DOTS
      .replaceAll(
        '\u065F',
        '',
      ) //ARABIC WAVY HAMZA BELOW
      .replaceAll(
        '\u0670',
        '',
      ) //ARABIC LETTER SUPERSCRIPT ALEF

      //Replace Waw Hamza Above by Waw
      .replaceAll(
        '\u0624',
        '\u0648',
      )

      //Replace Ta Marbuta by Ha
      .replaceAll(
        '\u0629',
        '\u0647',
      )

      //Replace Ya
      // and Ya Hamza Above by Alif Maksura
      .replaceAll(
        '\u064A',
        '\u0649',
      )
      .replaceAll(
        '\u0626',
        '\u0649',
      )

      // Replace Alifs with Hamza Above/Below
      // and with Madda Above by Alif
      .replaceAll(
        '\u0622',
        '\u0627',
      )
      .replaceAll(
        '\u0623',
        '\u0627',
      )
      .replaceAll(
        '\u0625',
        '\u0627',
      );
}
