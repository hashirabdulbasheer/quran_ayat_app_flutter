import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../features/auth/presentation/quran_login_screen.dart';
import '../../features/auth/presentation/quran_signup_screen.dart';
import '../../features/challenge/domain/models/quran_answer.dart';
import '../../features/challenge/domain/models/quran_question.dart';
import '../../features/challenge/presentation/my_challenge_submissions_screen.dart';
import '../../features/challenge/presentation/quran_answer_submission_confirmation_screen.dart';
import '../../features/challenge/presentation/quran_challenge_display_screen.dart';
import '../../features/challenge/presentation/quran_create_answer_screen.dart';
import '../../features/challenge/presentation/quran_create_question_screen.dart';
import '../../features/challenge/presentation/quran_edit_answer_screen.dart';
import '../../features/challenge/presentation/quran_message_display_screen.dart';
import '../../features/contextList/presentation/quran_context_list_screen.dart';
import '../../features/core/domain/app_state/app_state.dart';
import '../../features/home/presentation/quran_home_screen.dart';
import '../../features/newAyat/data/surah_index.dart';
import '../../features/newAyat/presentation/quran_new_ayat_screen.dart';
import '../../features/notes/domain/entities/quran_note.dart';
import '../../features/notes/presentation/quran_create_notes_screen.dart';
import '../../features/tags/domain/entities/quran_tag.dart';
import '../../features/tags/presentation/quran_results_screen.dart';
import '../../features/tags/presentation/quran_view_tags_screen.dart';
import '../../models/qr_user_model.dart';
import 'quran_router_enum.dart';

class QuranRoutes {
  static PageRoute<dynamic> getPageRoute(RouteSettings settings, bool isChallengeEnabled,) {
    /// check for url params
    /// if params present then display home or aya
    if(_isQueryParamsPresentInUrl()) {
        if(isChallengeEnabled) {
          return MaterialPageRoute<void>(
            builder: (_) => const QuranHomeScreen(),
          );
        }

        return MaterialPageRoute<void>(
          builder: (_) => const QuranNewAyatScreen(),
        );
    }

    QuranScreen screen = screenFromRouteString(settings.name ?? "");
    /// no params -> proceed to normal routing
    switch (screen) {
      case QuranScreen.root:
        return MaterialPageRoute<void>(
          builder: (_) => const QuranNewAyatScreen(),
        );

      case QuranScreen.home:
        return MaterialPageRoute<void>(
          builder: (_) => const QuranHomeScreen(),
        );

      case QuranScreen.signup:
        return MaterialPageRoute<void>(
          builder: (_) => const QuranSignUpScreen(),
        );

      case QuranScreen.login:
        return MaterialPageRoute<void>(
          builder: (_) => const QuranLoginScreen(),
        );

      case QuranScreen.context:
        final args = settings.arguments as Map<String, dynamic>;
        String title = args["title"] as String;
        SurahIndex index = args["index"] as SurahIndex;
        return MaterialPageRoute<void>(
          builder: (_) => QuranContextListScreen(
            title: title,
            index: index,
          ),
        );

      case QuranScreen.createNote:
        final args = settings.arguments as Map<String, dynamic>;
        QuranNote? note = args["note"] as QuranNote?;
        SurahIndex index = args["index"] as SurahIndex;
        return MaterialPageRoute<void>(
          builder: (_) => QuranCreateNotesScreen(
            note: note,
            index: index,
          ),
        );

      case QuranScreen.viewTags:
        final user = settings.arguments as QuranUser;
        return MaterialPageRoute<void>(
          builder: (_) => QuranViewTagsScreen(user: user),
        );

      case QuranScreen.mySubmissions:
        return MaterialPageRoute<void>(
          builder: (_) => const QuranMyChallengeSubmissionsScreen(),
        );

      case QuranScreen.createChallenge:
        final question = settings.arguments as QuranQuestion;
        return MaterialPageRoute<void>(
          builder: (_) => QuranCreateChallengeScreen(
            question: question,
          ),
        );

      case QuranScreen.createQuestion:
        return MaterialPageRoute<void>(
          builder: (_) => const QuranCreateQuestionScreen(),
        );

      case QuranScreen.challenge:
        final store = settings.arguments as Store<AppState>;
        return MaterialPageRoute<void>(
          builder: (_) => QuranChallengeDisplayScreen(store: store),
        );

      case QuranScreen.confirmation:
        final answerId = settings.arguments as String;
        return MaterialPageRoute<void>(
          builder: (_) =>
              QuranAnswerSubmissionConfirmationScreen(answerId: answerId),
        );

      case QuranScreen.editAnswer:
        final args = settings.arguments as Map<String, dynamic>;
        int questionId = args["questionId"] as int;
        QuranAnswer answer = args["answer"] as QuranAnswer;
        return MaterialPageRoute<void>(
          builder: (_) => QuranEditAnswerScreen(
            questionId: questionId,
            answer: answer,
          ),
        );

      case QuranScreen.message:
        final args = settings.arguments as Map<String, dynamic>;
        String title = args["title"] as String;
        String message = args["message"] as String;
        return MaterialPageRoute<void>(
          builder: (_) => QuranMessageDisplayScreen(
            title: title,
            message: message,
          ),
        );

      case QuranScreen.tagResults:
        final tag = settings.arguments as QuranTag;
        return MaterialPageRoute<void>(
          builder: (_) => QuranResultsScreen(
            tag: tag,
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

  static bool _isQueryParamsPresentInUrl() {
    if(kIsWeb) {
      final String? urlQuerySuraIndex = Uri.base.queryParameters["sura"];
      if(urlQuerySuraIndex != null) {
        return true;
      }
    }

    return false;
  }
}
