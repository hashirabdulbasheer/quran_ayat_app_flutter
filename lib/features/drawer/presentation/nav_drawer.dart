import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/settings/domain/settings_manager.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../misc/configs/app_config.dart';
import '../../../misc/design/design_system.dart';
import '../../../models/qr_response_model.dart';
import '../../../models/qr_user_model.dart';
import '../../../utils/utils.dart';
import '../../auth/domain/auth_factory.dart';
import '../../auth/presentation/quran_login_screen.dart';
import '../../auth/presentation/quran_profile_screen.dart';
import '../../bookmark/domain/bookmarks_manager.dart';
import '../../challenge/presentation/my_challenge_submissions_screen.dart';
import '../../challenge/presentation/quran_challenges_approval_screen.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../newAyat/data/surah_index.dart';
import '../../newAyat/domain/redux/actions/actions.dart';
import '../../notes/presentation/quran_view_notes_screen.dart';
import '../../settings/domain/constants/setting_constants.dart';
import '../../settings/presentation/quran_settings_screen.dart';
import '../../tags/presentation/quran_view_tags_screen.dart';
import 'widgets/nav_drawer_header.dart';
import 'widgets/nav_drawer_items_widget.dart';
import 'widgets/nav_drawer_row.dart';

class QuranNavDrawer extends StatefulWidget {
  final QuranUser? user;
  final QuranBookmarksManager bookmarksManager;

  const QuranNavDrawer({
    super.key,
    required this.user,
    required this.bookmarksManager,
  });

  @override
  State<QuranNavDrawer> createState() => _QuranNavDrawerState();
}

class _QuranNavDrawerState extends State<QuranNavDrawer> {
  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    QuranUser? userParam = widget.user;
    if (userParam != null) {
      /// Logged In
      return Drawer(
        backgroundColor: QuranDS.screenBackground,
        child: QuranNavDrawerItemsWidget(
          items: [
            const QuranNavDrawerHeaderWidget(),
            QuranNavDrawerRowWidget(
              context: context,
              title: 'Profile',
              icon: Icons.account_circle,
              destination: QuranProfileScreen(
                user: userParam,
                onLogOutTapped: () => {_onLogout(store)},
              ),
            ),
            QuranNavDrawerRowWidget(
              context: context,
              title: 'Bookmark',
              icon: Icons.bookmark,
              onSelected: () => _goToBookmark(store),
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
            QuranNavDrawerRowWidget(
              context: context,
              title: 'Blog',
              icon: Icons.comment_outlined,
              onSelected: () => _goToBlog(),
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
              title: 'Mobile Apps',
              icon: Icons.install_mobile,
              onSelected: () => _goToMobileApps(),
            ),
            QuranNavDrawerRowWidget(
              context: context,
              title: 'Settings',
              icon: Icons.settings,
              destination: const QuranSettingsScreen(),
            ),

            FutureBuilder<bool>(
                future:
                    QuranSettingsManager.instance.isChallengesFeatureEnabled(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    bool isEnabled = snapshot.data as bool;
                    if (isEnabled) {
                      return Column(
                        children: [
                          /// Approvals screen for admin user
                          if (store.state.isAdminUser)
                            QuranNavDrawerRowWidget(
                              context: context,
                              title: 'Approvals',
                              icon: Icons.admin_panel_settings_rounded,
                              destination:
                                  const QuranChallengesApprovalScreen(),
                            ),
                          const Divider(color: QuranDS.veryVeryLightColor,),
                          QuranNavDrawerRowWidget(
                            context: context,
                            title: 'Submissions',
                            icon: Icons.assignment_outlined,
                            destination:
                                const QuranMyChallengeSubmissionsScreen(),
                          ),
                          const Divider(color: QuranDS.veryVeryLightColor,),
                          QuranNavDrawerRowWidget(
                            context: context,
                            title: 'Feedback',
                            icon: Icons.email,
                            onSelected: () => _launchUrl(Uri.parse(
                              QuranSettingsConstants.feedbackEmailUrl,
                            )),
                          ),
                        ],
                      );
                    }
                  }
                  return QuranNavDrawerRowWidget(
                    context: context,
                    title: 'Feedback',
                    icon: Icons.email,
                    onSelected: () => _launchUrl(Uri.parse(
                      QuranSettingsConstants.feedbackEmailUrl,
                    )),
                  );
                }),
          ],
        ),
      );
    }

    /// Logged out
    return Drawer(
      backgroundColor: QuranDS.screenBackground,
      child: QuranNavDrawerItemsWidget(
        items: [
          const QuranNavDrawerHeaderWidget(),

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
            onSelected: () => _goToBookmark(store),
          ),
          QuranNavDrawerRowWidget(
            context: context,
            title: 'Blog',
            icon: Icons.comment_outlined,
            onSelected: () => _goToBlog(),
          ),
          QuranNavDrawerRowWidget(
            context: context,
            title: 'Mobile Apps',
            icon: Icons.install_mobile,
            onSelected: () => _goToMobileApps(),
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
    );
  }

  void _onLogout(Store<AppState> store) async {
    QuranResponse _ = await QuranAuthFactory.engine.logout();
    // clear stored data
    widget.bookmarksManager.localEngine.clear();
    store.dispatch(InitializeReaderScreenAction());
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      print('Could not launch $uri');
    }
  }

  void _goToBookmark(Store<AppState> store) {
    int? surah = store.state.reader.bookmarkState?.sura;
    int? aya = store.state.reader.bookmarkState?.aya;
    if (surah != null && aya != null) {
      StoreProvider.of<AppState>(context).dispatch(
        SelectParticularAyaAction(
          index: SurahIndex(
            surah,
            aya,
          ),
        ),
      );
    } else {
      QuranUtils.showMessage(
        context,
        "No Bookmarks found!",
      );
    }
  }

  void _goToBlog() {
    _launchUrl(Uri.parse(QuranAppConfig.blogUrl));
  }

  void _goToMobileApps() {
    QuranUtils.showMessage(
      context,
      "Coming soon...",
    );
  }
}
