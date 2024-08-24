import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/ai/domain/ai_type_enum.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/utils/logger_utils.dart';

class QuranAITriggerWidget extends StatelessWidget {
  final Icon icon;
  final QuranAIType type;
  final bool? isEnabled;

  const QuranAITriggerWidget({
    super.key,
    required this.icon,
    required this.type,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled == true ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: isEnabled == false,
        child: IconButton(
          onPressed: () {
            if (isEnabled == false) {
              return;
            }
            StoreProvider.of<AppState>(context).dispatch(ShowAIResponseAction(
              type: type,
            ));
            QuranLogger.logAnalyticsWithParams("ai-tapped", {
              'type': type.toString(),
            });
          },
          icon: icon,
        ),
      ),
    );
  }
}
