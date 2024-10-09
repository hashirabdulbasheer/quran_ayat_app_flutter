import 'package:flutter/material.dart';

extension WidgetsSpacer on List<Widget> {
  List<Widget> spacerDirectional({double? width, double? height}) {
    return expand((widget) {
      return [
        widget,
        SizedBox(
          width: width ?? 0,
          height: height ?? 0,
        )
      ];
    }).toList()
      ..removeLast();
  }
}
