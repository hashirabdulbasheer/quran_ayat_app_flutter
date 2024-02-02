import 'package:flutter/material.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';

import '../../features/auth/presentation/quran_login_screen.dart';
import '../../features/auth/presentation/quran_signup_screen.dart';
import '../../features/contextList/presentation/quran_context_list_screen.dart';
import '../../features/home/presentation/quran_home_screen.dart';
import '../../features/newAyat/presentation/quran_new_ayat_screen.dart';
import '../../features/notes/domain/entities/quran_note.dart';
import '../../features/notes/presentation/quran_create_notes_screen.dart';

class QuranRoutes {
  static PageRoute<dynamic> getPageRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          builder: (_) => const QuranNewAyatScreen(),
        );

      case '/home':
        return MaterialPageRoute<void>(
          builder: (_) => const QuranHomeScreen(),
        );

      case '/signup':
        return MaterialPageRoute<void>(
          builder: (_) => const QuranSignUpScreen(),
        );

      case '/login':
        return MaterialPageRoute<void>(
          builder: (_) => const QuranLoginScreen(),
        );

      case '/context':
        final args = settings.arguments as Map<String, dynamic>;
        String title = args["title"] as String;
        SurahIndex index = args["index"] as SurahIndex;
        return MaterialPageRoute<void>(
          builder: (_) => QuranContextListScreen(
            title: title,
            index: index,
          ),
        );

      case '/createNote':
        final args = settings.arguments as Map<String, dynamic>;
        QuranNote? note = args["note"] as QuranNote?;
        SurahIndex index = args["index"] as SurahIndex;
        return MaterialPageRoute<void>(
          builder: (_) => QuranCreateNotesScreen(
            note: note,
            index: index,
          ),
        );

      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Error page not found!")),
          ),
        );
    }
  }
}
