// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter_svg/svg.dart';

import '../common_ui_toolkit.dart';

List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

/// get responsive device width
double? getResponsiveDeviceWidth(double? value) =>
    value == null ? null : DEVICE_WIDTH * value;

/// get responsive device height
double? getResponsiveDeviceHeight(double? value) =>
    value == null ? null : DEVICE_HEIGHT * value;

/// handel margin, vertical, horizontal, top, bottom, left and right.
EdgeInsets getMarginEdgeInsets(CommonContainerModel? style) {
  final double? left = style!.marginLeft;
  final double? right = style.marginRight;
  final double? top = style.marginTop;
  final double? bottom = style.marginBottom;
  final double? vertical = style.marginVertical;
  final double? horizontal = style.marginHorizontal;
  final double? margin = style.margin;

  return EdgeInsets.fromLTRB(
    (getResponsiveDeviceWidth(left) ??
        getResponsiveDeviceWidth(horizontal) ??
        getResponsiveDeviceWidth(margin!))!,
    (getResponsiveDeviceHeight(top) ??
        getResponsiveDeviceHeight(vertical) ??
        getResponsiveDeviceHeight(margin!))!,
    (getResponsiveDeviceWidth(right) ??
        getResponsiveDeviceWidth(horizontal) ??
        getResponsiveDeviceWidth(margin!))!,
    (getResponsiveDeviceHeight(bottom) ??
        getResponsiveDeviceHeight(vertical) ??
        getResponsiveDeviceHeight(margin!))!,
  );
}

/// handel padding, vertical, horizontal, left, right, top and bottom.
EdgeInsets getPaddingEdgeInsets(dynamic style) {
  final double? left = style.paddingLeft;
  final double? right = style.paddingRight;
  final double? top = style.paddingTop;
  final double? bottom = style.paddingBottom;
  final double? vertical = style.paddingVertical;
  final double? horizontal = style.paddingHorizontal;
  final double? padding = style.padding;

  return EdgeInsets.fromLTRB(
    (getResponsiveDeviceWidth(left) ??
        getResponsiveDeviceWidth(horizontal) ??
        getResponsiveDeviceWidth(padding!))!,
    (getResponsiveDeviceHeight(top) ??
        getResponsiveDeviceHeight(vertical) ??
        getResponsiveDeviceHeight(padding!))!,
    (getResponsiveDeviceWidth(right) ??
        getResponsiveDeviceWidth(horizontal) ??
        getResponsiveDeviceWidth(padding!))!,
    (getResponsiveDeviceHeight(bottom) ??
        getResponsiveDeviceHeight(vertical) ??
        getResponsiveDeviceHeight(padding!))!,
  );
}

/// handel icon margin, vertical, horizontal, top, bottom, left and right.
EdgeInsets getIconMarginEdgeInsets(dynamic style) => EdgeInsets.fromLTRB(
      style.iconMarginLeft ?? style.iconMarginHorizontal ?? style.iconMargin!,
      style.iconMarginTop ?? style.iconMarginVertical ?? style.iconMargin!,
      style.iconMarginRight ?? style.iconMarginHorizontal ?? style.iconMargin!,
      style.iconMarginBottom ?? style.iconMarginVertical ?? style.iconMargin!,
    );

/// handel icon margin, vertical, horizontal, top, bottom, left and right.
EdgeInsets getContentPaddingEdgeInsets(dynamic style) => EdgeInsets.fromLTRB(
      style.contentPaddingLeft ??
          style.contentPaddingHorizontal ??
          style.contentPadding!,
      style.contentPaddingTop ??
          style.contentPaddingVertical ??
          style.contentPadding!,
      style.contentPaddingRight ??
          style.contentPaddingHorizontal ??
          style.contentPadding!,
      style.contentPaddingBottom ??
          style.contentPaddingVertical ??
          style.contentPadding!,
    );

/// return the icon and style with custom function.
CommonContainer getIcon(CommonIcon icon) {
  return CommonContainer(
    onPress: () {
      icon.onPress?.call();
    },
    style: icon.containerStyle ?? CommonContainerModel(),
    child: icon.path.runtimeType == IconData
        ? Icon(
            icon.path, // icon data takes only size without width and height, so we need to use size instead. we pass the width to be the size of the icon.
            size: icon.iconDataSize,
            color: getColorType(icon.color!),
          )
        : icon.path.startsWith('http')
            ? icon.path.endsWith('svg')
                ? SvgPicture.network(
                    icon.path,
                    color: getColorType(icon.color!),
                  )
                : Image.network(
                    icon.path,
                  )
            : icon.path.endsWith('svg')
                ? SvgPicture.asset(
                    icon.path,
                    color: getColorType(icon.color!),
                  )
                : Image.asset(
                    icon.path,
                  ),
  );
}

dynamic renderResponsiveWidth(double width) {
  return width;
}

/// render Color Type
dynamic getColorType(dynamic color) {
  if (color.runtimeType == Color || color.runtimeType == MaterialColor) {
    return color;
  } else if (color.runtimeType == int) {
    return Color(color);
  } else {
    return Colors.transparent;
  }
}

int calculateDateCount(int year, int month) {
  if (_leapYearMonths.contains(month)) {
    return 31;
  } else if (month == 2) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return 29;
    }
    return 28;
  }
  return 30;
}
