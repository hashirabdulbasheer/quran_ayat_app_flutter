import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../core/presentation/shimmer.dart';
import '../../newAyat/data/surah_index.dart';
import '../domain/entities/quran_tag.dart';
import '../domain/redux/actions/actions.dart';

class QuranAyatDisplayTagsWidget extends StatefulWidget {
  final SurahIndex currentIndex;

  const QuranAyatDisplayTagsWidget({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<QuranAyatDisplayTagsWidget> createState() =>
      _QuranAyatDisplayTagsWidgetState();
}

class _QuranAyatDisplayTagsWidgetState
    extends State<QuranAyatDisplayTagsWidget> {
  QuranTag? _selectedTag;

  @override
  Widget build(BuildContext context) {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    List<String>? tag = _fetchTag(
      widget.currentIndex,
    );

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
        QuranShimmer(
          isLoading: StoreProvider.of<AppState>(context).state.tags.isLoading,
          child: _body(
            user,
            tag,
          ),
        ),
      ],
    );
  }

  Widget _body(
    QuranUser? user,
    List<String>? tag,
  ) {
    if (user != null && tag != null && tag.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _tagsWidget(
          tag,
          user,
        ),
      );
    }

    return TextButton(
      onPressed: () => _displayAddTagDialog(
        user?.uid,
      ),
      child: const SizedBox(
        height: 30,
        child: Center(child: Text("Add Tag")),
      ),
    );
  }

  Widget _tagsWidget(
    List<String> tag,
    QuranUser user,
  ) {
    List<Widget> children = [];
    for (String tagString in tag) {
      children.add(Directionality(
        textDirection: TextDirection.ltr,
        child: Tooltip(
          message: "Remove tag",
          child: TextButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            onPressed: () => _displayRemovalConfirmationDialog(
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
          content: _addDialogTagSelectorField(),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            MaterialButton(
              color: Colors.blueGrey,
              textColor: Colors.white,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => {
                _onSaveButtonTapped(),
                Navigator.of(context).pop(),
              },
            ),
          ],
        );
      },
    );
  }

  Widget _addDialogTagSelectorField() {
    return DropdownSearch<QuranTag>(
      items: _fetchAllTags(),
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

  List<QuranTag> _fetchAllTags() {
    List<QuranTag> tags =
        List.from(StoreProvider.of<AppState>(context).state.tags.originalTags);
    // remove already added tags from the list
    List<String>? currentTagsForAya =
        StoreProvider.of<AppState>(context).state.tags.getTags(
              widget.currentIndex.sura,
              widget.currentIndex.aya,
            );
    if (currentTagsForAya != null && currentTagsForAya.isNotEmpty) {
      for (String alreadyAddedTag in currentTagsForAya) {
        tags.removeWhere((element) => element.name == alreadyAddedTag);
      }
    }

    return tags;
  }

  Future<void> _displayRemovalConfirmationDialog(
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
              color: Colors.blueGrey,
              textColor: Colors.white,
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => {
                _onRemoveButtonTapped(
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

  void _onSaveButtonTapped() {
    if (_selectedTag == null) return;
    String? newTagString = _selectedTag?.name.trim();
    // validation
    if (newTagString == null || newTagString.isEmpty) {
      // invalid
      return;
    }
    StoreProvider.of<AppState>(context).dispatch(AddTagAction(
      surahIndex: widget.currentIndex.sura,
      ayaIndex: widget.currentIndex.aya,
      tag: newTagString,
    ));
  }

  /// Actions
  ///

  bool _onRemoveButtonTapped(
    String selectedTag,
  ) {
    StoreProvider.of<AppState>(context).dispatch(RemoveTagAction(
      surahIndex: widget.currentIndex.sura,
      ayaIndex: widget.currentIndex.aya,
      tag: selectedTag,
    ));

    return true;
  }

  /// Helpers
  ///

  void _goToLoginScreen() {
    Navigator.pushNamed(
      context,
      "/login",
    ).then((value) => setState(() {}));
  }

  void _goToViewTagsScreen() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      return;
    }

    Navigator.pushNamed(
      context,
      "/viewTags",
      arguments: user,
    ).then((value) {
      setState(() {});
    });
  }

  List<String>? _fetchTag(
    SurahIndex currentIndex,
  ) {
    String key = "${currentIndex.sura}_${currentIndex.aya}";

    return StoreProvider.of<AppState>(context).state.tags.tags[key];
  }
}
