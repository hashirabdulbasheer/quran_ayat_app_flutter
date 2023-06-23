import 'package:flutter/material.dart';
import '../../../models/qr_user_model.dart';
import '../../../utils/nav_utils.dart';
import '../domain/entities/quran_master_tag.dart';
import '../domain/tags_manager.dart';

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
  List<QuranMasterTag> _tags = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tags"),
          actions: [
            IconButton(
              onPressed: () => _displayAddTagDialog(
                widget.user.uid,
              ),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<QuranMasterTag>>(
                future: QuranTagsManager.instance.fetchAll(widget.user.uid),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<QuranMasterTag>> snapshot,
                ) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        _tags = snapshot.data as List<QuranMasterTag>;
                        if (_tags.isEmpty) {
                          return Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 50,
                              child: TextButton(
                                child: const Text(
                                  'Add new tag',
                                ),
                                onPressed: () => _displayAddTagDialog(
                                  widget.user.uid,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return ListTile(
                              title: Text(_tags[index].name),
                              onTap: () => _navigateToResults(_tags[index]),
                            );
                          },
                          separatorBuilder: (
                            context,
                            index,
                          ) {
                            return const Divider(thickness: 1);
                          },
                          itemCount: _tags.length,
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _displayAddTagDialog(
    String? userId,
  ) async {
    if (userId == null) return;
    _textEditingController.text = "";

    return showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          title: const Text(
            'Select Tag',
          ),
          content: TextField(
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
                _saveTag(userId),
                Navigator.of(context).pop(),
                setState(() {}),
                _showMessage("Saved 👍"),
              },
            ),
          ],
        );
      },
    );
  }

  void _saveTag(String userId) async {
    String newTag = _textEditingController.text.toLowerCase().trim();
    if (newTag.isEmpty || _tags.any((item) => item.containsTag(newTag))) {
      _showMessage("Error saving tag 😔");

      return;
    }
    await QuranTagsManager.instance.createMaster(
      userId,
      newTag,
    );
  }

  void _navigateToResults(QuranMasterTag tag) {
    if (tag.ayas.isEmpty) {
      _showMessage("Tag not used");

      return;
    }

    QuranNavigator.navigationToResultsScreen(
      context,
      tag,
    );
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
