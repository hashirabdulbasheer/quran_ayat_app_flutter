import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import '../../../misc/enums/quran_status_enum.dart';
import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../../auth/presentation/quran_login_screen.dart';
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
        surahIndex != null && user != null
            ? FutureBuilder<QuranTag?>(
                future: QuranTagsManager.instance.fetch(
                  user.uid,
                  surahIndex,
                  widget.ayaIndex,
                ),
                // async work
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuranTag?> snapshot,
                ) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text('Loading....'),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        QuranTag? tag = snapshot.data;
                        if (tag != null && tag.tag.isNotEmpty) {
                          return Row(
                            children: _tagsWidget(
                              tag,
                              user,
                            ),
                          );
                        }

                        return TextButton(
                          onPressed: () => _displayAddTagDialog(
                            user.uid,
                          ),
                          child: const SizedBox(
                            height: 30,
                            child: Center(child: Text("Add Tag")),
                          ),
                        );
                      }
                  }
                },
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

  List<Widget> _tagsWidget(
    QuranTag tag,
    QuranUser user,
  ) {
    List<Widget> children = [];
    for (String tagString in tag.tag) {
      children.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(
            10,
            0,
            0,
            0,
          ),
          decoration: const BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tagString,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              Tooltip(
                message: "Remove tag",
                child: SizedBox(
                  width: 30,
                  child: TextButton(
                    onPressed: () => _displayRemovalConfirmationDialog(
                      tag,
                      tagString,
                      user.uid,
                    ),
                    child: const Text(
                      "X",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return children;
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
            const Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Text(
            "No tags found\n\nPlease add a tag through Menu Drawer-Tags",
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
}
