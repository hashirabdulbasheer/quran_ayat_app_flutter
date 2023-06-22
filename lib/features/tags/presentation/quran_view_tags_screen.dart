import 'package:flutter/material.dart';
import 'package:quran_ayat/features/tags/domain/entities/quran_index.dart';
import 'package:quran_ayat/utils/nav_utils.dart';

import '../../../models/qr_user_model.dart';
import '../domain/entities/quran_tag.dart';
import '../domain/tags_manager.dart';

class QuranTagForView {

}

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
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tags"),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<QuranTag>>(
                future: QuranTagsManager.instance.fetchAll(widget.user.uid),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<QuranTag>> snapshot,
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
                        List<QuranTag> tags = snapshot.data as List<QuranTag>;
                        if (tags.isEmpty) {
                          return const Center(child: Text('No tags'));
                        }

                        List<String> tagStrings = _mapToString(tags);

                        return ListView.separated(
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return ListTile(
                              title: Text(tagStrings[index]),
                              onTap: ()  {
                                List<QuranIndex> indices = [];
                                for(QuranTag tag in tags) {
                                  List<String> tagsIntag = tag.tag;
                                  if(tagsIntag.isNotEmpty && tagsIntag.contains(tagStrings[index])) {
                                    indices.add(QuranIndex(surahIndex: tag.suraIndex, ayaIndex: tag.ayaIndex));
                                  }
                                }
                                QuranNavigator.navigationToResultsScreen(context, indices);
                              },
                            );
                          },
                          separatorBuilder: (
                            context,
                            index,
                          ) {
                            return const Divider(thickness: 1);
                          },
                          itemCount: tagStrings.length,
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

  List<String> _mapToString(List<QuranTag> tags) {
    Set<String> tagStrings = {};
    for (QuranTag quranTag in tags) {
      List<String> tags = quranTag.tag;
      tagStrings.addAll(tags);
    }

    return tagStrings.toList();
  }
}
