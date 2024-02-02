import 'package:flutter/material.dart';

import '../../features/auth/presentation/quran_signup_screen.dart';
import '../../features/home/presentation/quran_home_screen.dart';
import '../../features/newAyat/presentation/quran_new_ayat_screen.dart';

class QuranRoutes {
  static PageRoute getPageRoute(RouteSettings settings) {
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

      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Error page not found!")),
          ),
        );
    }
  }
}
