import 'package:flutter/material.dart';

import '../../../models/qr_user_model.dart';
import '../domain/entities/quran_tag.dart';
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

                        return ListView.separated(
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return ListTile(
                              title: Text(tags[index].tag as String),
                              onTap: () => {print("tag tapped")},
                            );
                          },
                          separatorBuilder: (
                            context,
                            index,
                          ) {
                            return const Divider(thickness: 1);
                          },
                          itemCount: tags.length,
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

  List<Widget> _tagChildWidgets(QuranTag tag) {
    List<Widget> children = [];
    List<String> tags = tag.tag;
    for (String tag in tags) {
      children.add(Text(tag));
    }

    return children;
  }
}
