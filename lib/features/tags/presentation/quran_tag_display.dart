import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:quran_ayat/features/tags/presentation/quran_view_tags_screen.dart';
import '../../../misc/enums/quran_status_enum.dart';
import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../../auth/presentation/quran_login_screen.dart';
import '../../core/domain/app_state.dart';
import '../domain/entities/quran_master_tag.dart';
import '../domain/entities/quran_master_tag_aya.dart';
import '../domain/entities/quran_tag.dart';
import '../domain/tags_manager.dart';

class QuranAyatDisplayTagsWidget extends StatefulWidget {
  final NQSurahTitle? currentlySelectedSurah;
  final int ayaIndex;
  final ValueNotifier<bool> continuousMode;

  const QuranAyatDisplayTagsWidget({
    Key? key,
    required this.currentlySelectedSurah,
    required this.ayaIndex,
    required this.continuousMode,
  }) : super(key: key);

  @override
  State<QuranAyatDisplayTagsWidget> createState() =>
      _QuranAyatDisplayTagsWidgetState();
}

class _QuranAyatDisplayTagsWidgetState
    extends State<QuranAyatDisplayTagsWidget> {
  QuranMasterTag? _selectedTag;

  @override
  Widget build(BuildContext context) {
    // logged in
    if (widget.currentlySelectedSurah == null) {
      return Container();
    }

    QuranUser? user = QuranAuthFactory.engine.getUser();
    int? surahIndex = widget.currentlySelectedSurah?.number;
    QuranTag? tag;
    if (surahIndex != null) {
      tag = _fetchTag(
        surahIndex,
        widget.ayaIndex,
      );
    }

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.black12),
            ),
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.fromLTRB(
            10,
            0,
            10,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tags"),
              ElevatedButton(
                onPressed: () => _displayAddTagDialog(
                  user?.uid,
                ),
                child: const Text("Add"),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        surahIndex != null && user != null && tag != null && tag.tag.isNotEmpty
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _tagsWidget(
                  tag,
                  user,
                ),
              )
            : TextButton(
                onPressed: () => _displayAddTagDialog(
                  user?.uid,
                ),
                child: const SizedBox(
                  height: 30,
                  child: Center(child: Text("Add Tag")),
                ),
              ),
      ],
    );
  }

  Widget _tagsWidget(
    QuranTag tag,
    QuranUser user,
  ) {
    List<Widget> children = [];
    for (String tagString in tag.tag) {
      children.add(Directionality(
        textDirection: TextDirection.ltr,
        child: Tooltip(
          message: "Remove tag",
          child: TextButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white60),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            onPressed: () => _displayRemovalConfirmationDialog(
              tag,
              tagString,
              user.uid,
            ),
            icon: const Icon(
              Icons.close,
              size: 20,
              color: Colors.black87,
            ),
            label: Text(
              tagString,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ));
      children.add(const SizedBox(
        width: 10,
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    );
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Dialog Utils
  ///
  ///
  Future<void> _displayAddTagDialog(
    String? userId,
  ) async {
    if (userId == null) {
      _goToLoginScreen();

      return;
    }

    _selectedTag = null;

    return showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          title: const Text(
            'Select Tag',
          ),
          content: _addDialogTagSelectorField(
            userId,
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
                _onSaveButtonTapped(userId),
                Navigator.of(context).pop(),
              },
            ),
          ],
        );
      },
    );
  }

  Widget _addDialogTagSelectorField(String userId) {
    return DropdownSearch<QuranMasterTag>(
      asyncItems: (_) => _fetchAllTags(userId),
      popupProps: PopupPropsMultiSelection.menu(
        showSearchBox: true,
        emptyBuilder: (
          context,
          searchEntry,
        ) =>
            Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text("No tags found"),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.white70,
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _goToViewTagsScreen(),
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Click here to add a tag.",
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Tag",
          hintText: "select tag",
        ),
        textAlign: TextAlign.start,
      ),
      onChanged: (value) => {
        if (value != null) {_selectedTag = value},
      },
      itemAsString: (item) => item.name,
      selectedItem: _selectedTag,
    );
  }

  Future<List<QuranMasterTag>> _fetchAllTags(
    String userId,
  ) async {
    return Future.value(
      await QuranTagsManager.instance.fetchAll(userId),
    );
  }

  Future<void> _displayRemovalConfirmationDialog(
    QuranTag tag,
    String selectedTag,
    String? userId,
  ) async {
    if (userId == null) return;

    return showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          title: const Text(
            'Remove Tag?',
          ),
          content: Text(
            "Are you sure that you want to remove - \"$selectedTag\"?",
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
                'Delete',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              onPressed: () => {
                _onRemoveButtonTapped(
                  userId,
                  tag,
                  selectedTag,
                ),
                Navigator.of(context).pop(),
              },
            ),
          ],
        );
      },
    );
  }

  void _onSaveButtonTapped(
    String userId,
  ) async {
    if (await _saveTag(userId)) {
      _showMessage(
        "Saved 👍",
      );
    } else {
      _showMessage(
        "Error Saving tag 😔",
      );
    }
  }

  void _onRemoveButtonTapped(
    String userId,
    QuranTag tag,
    String selectedTag,
  ) async {
    if (await _removeTag(
      userId,
      tag,
      selectedTag,
    )) {
      _showMessage(
        "Removed tag  👍",
      );
    } else {
      _showMessage(
        "Error Removing tag 😔",
      );
    }
  }

  /// Actions
  ///

  Future<bool> _removeTag(
    String userId,
    QuranTag currentTag,
    String selectedTag,
  ) async {
    int? surahIndex = widget.currentlySelectedSurah?.number;
    // validation
    if (surahIndex == null) {
      // invalid
      return false;
    }
    QuranTagsManager manager = QuranTagsManager.instance;
    if (currentTag.tag.length > 1) {
      // more than one items
      List<String> currentTagStrings = currentTag.tag;
      currentTagStrings.remove(selectedTag);
      currentTag = currentTag.copyWith(
        tag: currentTagStrings,
        status: QuranStatusEnum.updated,
      );
      await manager.update(
        userId,
        currentTag,
      );
    } else {
      // only one item
      await manager.delete(
        userId,
        currentTag,
      );
    }

    // update tag-master to remove the aya infor
    try {
      List<QuranMasterTag> masterTags = await _fetchAllTags(userId);
      QuranMasterTag masterTag =
          masterTags.firstWhere((element) => element.name == selectedTag);
      masterTag.ayas.removeWhere((element) =>
          element.suraIndex == currentTag.suraIndex &&
          element.ayaIndex == currentTag.ayaIndex);
      await manager.updateMaster(
        userId,
        masterTag,
      );
    } catch (_) {}

    setState(() {});

    return true;
  }

  Future<bool> _saveTag(
    String userId,
  ) async {
    if (_selectedTag == null) return false;

    String? newTagString = _selectedTag?.name.toLowerCase().trim();
    int? surahIndex = widget.currentlySelectedSurah?.number;
    // validation
    if (newTagString == null || newTagString.isEmpty || surahIndex == null) {
      // invalid
      return false;
    }

    QuranTagsManager manager = QuranTagsManager.instance;
    QuranTag? currentTag = await manager.fetch(
      userId,
      surahIndex,
      widget.ayaIndex,
    );

    if (currentTag == null || currentTag.tag.isEmpty) {
      // create a new tag
      return await _createNewTag(
        userId,
        surahIndex,
        widget.ayaIndex,
        newTagString,
      );
    } else {
      // update existing tag
      return await _updateTag(
        userId,
        currentTag,
        newTagString,
      );
    }
  }

  /// Helpers
  ///

  Future<bool> _createNewTag(
    String userId,
    int suraIndex,
    int ayaIndex,
    String newTagString,
  ) async {
    QuranTagsManager manager = QuranTagsManager.instance;
    QuranTag newTag = QuranTag(
      suraIndex: suraIndex,
      ayaIndex: ayaIndex,
      tag: [newTagString],
      localId: DateTime.now().millisecondsSinceEpoch.toString(),
      createdOn: DateTime.now().millisecondsSinceEpoch,
      status: QuranStatusEnum.created,
    );

    // create tag
    await manager.create(
      userId,
      newTag,
    );

    // update tag-master to add the aya infor
    _selectedTag?.ayas.add(QuranMasterTagAya(
      suraIndex: newTag.suraIndex,
      ayaIndex: newTag.ayaIndex,
    ));
    await manager.updateMaster(
      userId,
      _selectedTag,
    );

    setState(() {
      _selectedTag = null;
    });

    return true;
  }

  Future<bool> _updateTag(
    String userId,
    QuranTag currentTag,
    String newTagString,
  ) async {
    if (currentTag.tag.contains(newTagString)) {
      // duplicate
      return false;
    }

    // there is no duplicate
    // already contains tags - so update
    QuranTagsManager manager = QuranTagsManager.instance;
    List<String> currentTagStrings = currentTag.tag;
    currentTagStrings.add(newTagString);
    currentTag = currentTag.copyWith(
      tag: currentTagStrings,
      status: QuranStatusEnum.updated,
    );

    // update tag
    await manager.update(
      userId,
      currentTag,
    );

    // update tag-master to add the aya infor
    _selectedTag?.ayas.add(QuranMasterTagAya(
      suraIndex: currentTag.suraIndex,
      ayaIndex: currentTag.ayaIndex,
    ));
    await manager.updateMaster(
      userId,
      _selectedTag,
    );

    setState(() {
      _selectedTag = null;
    });

    return true;
  }

  void _goToLoginScreen() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const QuranLoginScreen()),
    ).then((value) {
      setState(() {});
    });
  }

  void _goToViewTagsScreen() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      return;
    }

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranViewTagsScreen(
          user: user,
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  QuranTag? _fetchTag(
    int surahIndex,
    int ayaIndex,
  ) {
    String key = "${surahIndex}_$ayaIndex";
    List<String>? tags = StoreProvider.of<AppState>(context).state.tags[key];

    return QuranTag(
      suraIndex: surahIndex,
      ayaIndex: ayaIndex,
      tag: tags ?? [],
      localId: "${DateTime.now().millisecondsSinceEpoch}",
      createdOn: DateTime.now().millisecondsSinceEpoch,
      status: QuranStatusEnum.created,
    );
  }
}
