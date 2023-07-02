import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/utils/utils.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/qr_user_model.dart';
import '../../../utils/nav_utils.dart';
import '../../core/domain/app_state/app_state.dart';
import '../domain/entities/quran_tag.dart';
import '../domain/redux/actions/actions.dart';
import '../domain/redux/tag_state.dart';

class QuranViewTagsScreen extends StatefulWidget {
  final QuranUser user;

  const QuranViewTagsScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<QuranViewTagsScreen> createState() => _QuranViewTagsScreenState();
}

class _QuranViewTagsScreenState extends State<QuranViewTagsScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tags"),
          actions: [
            IconButton(
              onPressed: () => _exportTags(),
              icon: const Icon(
                Icons.share,
              ),
            ),
            IconButton(
              onPressed: () => _displayAddTagDialog(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: StoreBuilder<AppState>(
          onDidChange: (
            old,
            updated,
          ) =>
              _onStoreDidChange(),
          builder: (
            BuildContext context,
            Store<AppState> store,
          ) {
            List<QuranTag> tags = _tags();

            return Column(
              children: [
                Expanded(
                  child: tags.isEmpty
                      ? Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 50,
                            child: TextButton(
                              child: const Text(
                                'Add new tag',
                              ),
                              onPressed: () => _displayAddTagDialog(),
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return ListTile(
                              title: Text(tags[index].name),
                              onTap: () => _navigateToResults(tags[index]),
                            );
                          },
                          separatorBuilder: (
                            context,
                            index,
                          ) {
                            return const Divider(thickness: 1);
                          },
                          itemCount: tags.length,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _displayAddTagDialog() {
    _textEditingController.text = "";

    return showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          title: const Text(
            'Create Tag',
          ),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter tag',
            ),
            controller: _textEditingController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            MaterialButton(
              color: Colors.white60,
              textColor: Colors.white,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              onPressed: () => {
                _saveTag(),
                Navigator.of(context).pop(),
              },
            ),
          ],
        );
      },
    );
  }

  void _saveTag() {
    String newTag = _textEditingController.text.trim();
    if (newTag.isEmpty || _tags().any((item) => item.containsTag(newTag))) {
      QuranUtils.showMessage(
        context,
        "Error saving tag 😔",
      );

      return;
    }
    StoreProvider.of<AppState>(context).dispatch(CreateTagAction(
      surahIndex: 0,
      ayaIndex: 0,
      tag: newTag,
    ));
  }

  void _navigateToResults(QuranTag tag) {
    if (tag.ayas.isEmpty) {
      QuranUtils.showMessage(
        context,
        "Tag not used",
      );

      return;
    }

    if (tag.ayas.length == 1) {
      // there is only one aya, go directly to the aya
      QuranNavigator.navigateToAyatScreen(
        context,
        surahIndex: tag.ayas.first.suraIndex - 1,
        ayaIndex: tag.ayas.first.ayaIndex,
      );

      return;
    }

    QuranNavigator.navigationToResultsScreen(
      context,
      tag,
    );
  }

  List<QuranTag> _tags() =>
      StoreProvider.of<AppState>(context).state.tags.originalTags;

  void _exportTags() {
    String exported = "";
    List<QuranTag> allTags = _tags();
    for (QuranTag tag in allTags) {
      String tagString = "${tag.name}: ";
      tagString +=
          tag.ayas.map((val) => "${val.suraIndex}:${val.ayaIndex}").join(',');
      exported += "$tagString\n";
    }

    Share.share(
      'Tags exported from uxQuran QuranAyat app: https://uxquran.com\n\n$exported',
    );
  }

  void _onStoreDidChange() {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    var listOfActions = [
      (CreateTagSucceededAction).toString(),
    ];
    if (listOfActions.contains(store.state.lastActionStatus.action)) {
      QuranUtils.showMessage(
        context,
        store.state.lastActionStatus.message,
      );
      store.dispatch(AppStateResetStatusAction());
    }
  }
}
