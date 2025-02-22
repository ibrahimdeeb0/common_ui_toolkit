import 'package:flutter/foundation.dart';

import '../../../common_ui_toolkit.dart';

enum FormateType {
  dmy,
  ymd,
}

class CommonDatePickerTheme with DiagnosticableTreeMixin {
  const CommonDatePickerTheme({
    this.cancelStyle = const TextStyle(color: Colors.black54, fontSize: 16),
    this.doneStyle = const TextStyle(color: Colors.blue, fontSize: 16),
    this.itemStyle = const TextStyle(color: Color(0xFF000046), fontSize: 18),
    this.backgroundColor = Colors.white,
    this.headerColor,
    this.containerHeight = 210.0,
    this.titleHeight = 44.0,
    this.itemHeight = 36.0,
    this.borderRadius = 16.0,
    this.formateType = FormateType.dmy,
  });

  final TextStyle cancelStyle;
  final TextStyle doneStyle;
  final TextStyle itemStyle;
  final Color backgroundColor;
  final Color? headerColor;
  final double? borderRadius;

  final double containerHeight;
  final double titleHeight;
  final double itemHeight;
  final FormateType formateType;
}
