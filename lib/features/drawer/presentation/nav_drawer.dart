import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/settings/domain/constants/setting_constants.dart';
import 'package:quran_ayat/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/qr_response_model.dart';
import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../../auth/presentation/quran_login_screen.dart';
import '../../auth/presentation/quran_profile_screen.dart';
import '../../bookmark/domain/bookmarks_manager.dart';
import '../../notes/presentation/quran_view_notes_screen.dart';
import '../../settings/presentation/quran_settings_screen.dart';
import '../../tags/presentation/quran_view_tags_screen.dart';
import 'widgets/nav_drawer_header.dart';
import 'widgets/nav_drawer_items_widget.dart';
import 'widgets/nav_drawer_row.dart';

class QuranNavDrawer extends StatefulWidget {
  final QuranUser? user;
  final QuranBookmarksManager bookmarksManager;

  const QuranNavDrawer({
    Key? key,
    required this.user,
    required this.bookmarksManager,
  }) : super(key: key);

  @override
  State<QuranNavDrawer> createState() => _QuranNavDrawerState();
}

class _QuranNavDrawerState extends State<QuranNavDrawer> {
  int numOfTaps = 5;

  @override
  Widget build(BuildContext context) {
    QuranUser? userParam = widget.user;
    if (userParam != null) {
      /// Logged In
      return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: Drawer(
          child: QuranNavDrawerItemsWidget(
            items: [
              const QuranNavDrawerHeaderWidget(),
              QuranNavDrawerRowWidget(
                context: context,
                title: 'Profile',
                icon: Icons.account_circle,
                destination: QuranProfileScreen(
                  user: userParam,
                  onLogOutTapped: () => {_onLogout()},
                ),
              ),
              QuranNavDrawerRowWidget(
                context: context,
                title: 'Bookmark',
                icon: Icons.bookmark,
                onSelected: () => _goToBookmark(),
              ),
              QuranNavDrawerRowWidget(
                context: context,
                title: 'Notes',
                icon: Icons.edit_note_sharp,
                destination: QuranViewNotesScreen(user: userParam),
              ),
              QuranNavDrawerRowWidget(
                context: context,
                title: 'Tags',
                icon: Icons.tag,
                destination: QuranViewTagsScreen(user: userParam),
              ),
              // TODO: Search in menu disabled, enable when fixed - Logged IN
              // QuranNavDrawerRowWidget(
              //   context: context,
              //   title: 'Search',
              //   icon: Icons.search_rounded,
              //   destination: const QuranSearchScreen(),
              // ),
              QuranNavDrawerRowWidget(
                context: context,
                title: 'Settings',
                icon: Icons.settings,
                destination: const QuranSettingsScreen(),
              ),
              QuranNavDrawerRowWidget(
                context: context,
                title: 'Feedback',
                icon: Icons.email,
                onSelected: () => _launchUrl(Uri.parse(
                  QuranSettingsConstants.feedbackEmailUrl,
                )),
              ),
            ],
          ),
        ),
      );
    }

    /// Logged out
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.white),
      child: Drawer(
        child: QuranNavDrawerItemsWidget(
          items: [
            GestureDetector(
              onTap: () => {
                if (numOfTaps > 0)
                  {
                    numOfTaps = numOfTaps - 1,
                  },
                setState(() {}),
              },
              child: const QuranNavDrawerHeaderWidget(),
            ),

            if (numOfTaps == 0)
              QuranNavDrawerRowWidget(
                context: context,
                title: 'Login',
                icon: Icons.account_circle_outlined,
                destination: const QuranLoginScreen(),
              ),

            // TODO: Search in menu disabled, enable when fixed - Logged OUT
            // QuranNavDrawerRowWidget(
            //   context: context,
            //   title: 'Search',
            //   icon: Icons.search_rounded,
            //   destination: const QuranSearchScreen(),
            // ),
            QuranNavDrawerRowWidget(
              context: context,
              title: 'Bookmark',
              icon: Icons.bookmark,
              onSelected: () => _goToBookmark(),
            ),
            QuranNavDrawerRowWidget(
              context: context,
              title: 'Settings',
              icon: Icons.settings,
              destination: const QuranSettingsScreen(),
            ),
            QuranNavDrawerRowWidget(
              context: context,
              title: 'Feedback',
              icon: Icons.email,
              onSelected: () => _launchUrl(Uri.parse(
                QuranSettingsConstants.feedbackEmailUrl,
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _onLogout() async {
    QuranResponse _ = await QuranAuthFactory.engine.logout();
    // clear stored data
    widget.bookmarksManager.localEngine.clear();
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      print('Could not launch $uri');
    }
  }

  void _goToBookmark() {
    var surah = StoreProvider.of<AppState>(context)
        .state
        .reader
        .bookmarkState
        .suraIndex;
    var aya =
        StoreProvider.of<AppState>(context).state.reader.bookmarkState.ayaIndex;
    if (surah != null && aya != null) {
      StoreProvider.of<AppState>(context).dispatch(
        SelectParticularAyaAction(
          surah: surah + 1,
          aya: aya,
        ),
      );
    } else {
      QuranUtils.showMessage(
        context,
        "No Bookmarks found!",
      );
    }
  }
}
