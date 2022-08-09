import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../models/qr_user_model.dart';
import '../../../quran_search_screen.dart';
import '../../auth/presentation/quran_login_screen.dart';
import '../../auth/presentation/quran_profile_screen.dart';
import '../../notes/presentation/quran_view_notes_screen.dart';

class QuranNavDrawer extends StatelessWidget {
  final QuranUser? user;

  const QuranNavDrawer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = user != null
        ? _loggedInDrawerItems(context, user!)
        : _loggedOutDrawerItems(context);
    return Drawer(
        child: ListView.separated(
      separatorBuilder: (context, index) {
        if (index > 0) {
          return const Divider(thickness: 1);
        }
        return const Divider();
      },
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return items[index];
      },
      itemCount: items.length,
    ));
  }

  List<Widget> _loggedInDrawerItems(BuildContext context, QuranUser user) => [
        _header(context),
        _row(context,
            title: 'Profile',
            destination: QuranProfileScreen(user: user),
            icon: Icons.account_circle),
        _row(context,
            title: 'Notes',
            destination: QuranViewNotesScreen(user: user),
            icon: Icons.edit_note_sharp),
        _row(context,
            title: 'Search',
            destination: const QuranSearchScreen(),
            icon: Icons.search_rounded),
      ];

  List<Widget> _loggedOutDrawerItems(BuildContext context) => [
        _header(context),
        _row(context,
            title: 'Login',
            destination: const QuranLoginScreen(),
            icon: Icons.account_circle_outlined),
        _row(context,
            title: 'Search',
            destination: const QuranSearchScreen(),
            icon: Icons.search_rounded),
      ];

  /// Header
  _header(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: const Text(
          "$appVersion uxQuran",
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
    );
  }

  /// Row
  _row(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget destination}) {
    return ListTile(
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
