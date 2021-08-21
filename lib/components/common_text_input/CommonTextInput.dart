import 'package:common_ui_toolkit/models/CommonIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:common_ui_toolkit/index.dart';
import 'package:common_ui_toolkit/models/CommonTextInputModel.dart';

import '../../index.dart';
import '../../utils/index.dart';

class CommonTextInput extends StatefulWidget {
  CommonTextInputModel? style;
  CommonContainerModel? containerStyle;
  Function? onChanged;
  TextEditingController? textEditingController;

  CommonTextInput({
    this.style,
    this.containerStyle,
    this.onChanged,
    this.textEditingController,
  });

  @override
  _CommonTextInputState createState() => _CommonTextInputState();
}

class _CommonTextInputState extends State<CommonTextInput> {
  CommonTextInputModel? style;

  @override
  Widget build(BuildContext context) {
    style = widget.style ?? CommonTextInputModel();
    widget.textEditingController = TextEditingController(text: style!.text);
    return CommonContainer(
      style: widget.containerStyle,
      child: TextFormField(
        controller: widget.textEditingController,
        textInputAction: style!.textInputAction,
        textAlign: style!.textAlign!,
        focusNode: style!.foucsNode,
        style: style!.textStyle ??
            TextStyle(
              color: Color(style!.textColor!),
              fontSize: style!.fontSize,
            ),
        scrollPhysics: BouncingScrollPhysics(),
        minLines: style!.minLines,
        maxLines: style!.maxLines,
        maxLength: style!.maxLength,

        /// If there is only textInputPattern then we create a list that handles only one item of input formatters,
        /// if we receive a list of input formatters, we handle it as a list of items.
        inputFormatters: style!.textInputPattern != null
            ? [
                FilteringTextInputFormatter.allow(style!.textInputPattern!),
              ]
            : style!.textInputFormatters ?? null,
        readOnly: style!.readOnly!,
        obscureText: style!.obscureText!,
        keyboardType: style!.textInputType,
        enabled: style!.enabled,
        cursorHeight: style!.cursorHeight,
        cursorWidth: style!.cursorWidth!,
        showCursor: style!.showCursor,
        cursorColor: Color(style!.cursorColor!),
        cursorRadius: style!.cursorRadius,
        decoration: style!.inputDecoration ??
            InputDecoration(
              counterText: '',
              fillColor: Color(style!.fillColor!),
              filled: style!.fillColor != null,
              contentPadding: getContentPaddingEdgeInsets(style),
              hintText: style!.hint,
              hintStyle: style!.hintStyle ??
                  TextStyle(
                    color: style!.enabled!
                        ? Color(style!.hintColor!)
                        : Color(style!.disabledColor!),
                  ),
              isCollapsed: style!.isCollapsed!,
              prefixIcon: style!.prefixWidget ??
                  (style!.prefixIcon != null
                      ? getIcon(
                          style!.prefixIcon!,
                        )
                      : null),
              suffixIcon: style!.suffixWidget ??
                  (style!.suffixIcon != null
                      ? getIcon(
                          style!.suffixIcon!,
                        )
                      : null),
              prefixIconConstraints: BoxConstraints(
                minWidth: style!.prefixMinWidth!,
                minHeight: style!.prefixMinHeight!,
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: style!.suffixMinWidth!,
                minHeight: style!.suffixMinHeight!,
              ),
              border: getOutlineInputBorder(
                borderColor: style!.disabledColor!,
              ),
              ////The border to display when the InputDecorator has the focus and is not showing an error.
              focusedBorder: getOutlineInputBorder(
                borderColor: style!.focusBorderColor!,
              ),
              enabledBorder: getOutlineInputBorder(
                borderColor: style!.enabledBorderColor!,
              ),
              disabledBorder: getOutlineInputBorder(
                borderColor: style!.disabledBorderColor!,
              ),
              errorBorder: getOutlineInputBorder(
                borderColor: style!.errorBorderColor!,
              ),
              alignLabelWithHint: true,
            ),
        onChanged: (value) {
          widget.onChanged!(value);
        },
      ),
    );
  }

  getIcon(CommonIcon icon) {
    return CommonContainer(
      style: icon.containerStyle ?? CommonContainerModel(),
      child: icon.path.runtimeType == IconData
          ? Icon(
              icon.path, // icon data takes only size without width and height, so we need to use size instead. we pass the width to be the size of the icon.
              size: icon.iconDataSize,
              color: generateIconColor(icon.color),
            )
          : icon.path.startsWith('http')
              ? icon.path.endsWith('svg')
                  ? SvgPicture.network(
                      icon.path,
                      color: generateIconColor(icon.color),
                    )
                  : Image.network(
                      icon.path,
                    )
              : icon.path.endsWith('svg')
                  ? SvgPicture.asset(
                      icon.path,
                      color: generateIconColor(icon.color),
                    )
                  : Image.asset(
                      icon.path,
                    ),
    );
  }

  generateIconColor(color) => Color(
        style!.enabled! ? color : style!.disabledColor!,
      );

  getOutlineInputBorder({borderColor}) {
    return style!.underlined!
        ? UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(borderColor),
              width: style!.borderWidth!,
            ),
          )
        : OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(style!.radius!),
            ),
            borderSide: style!.withBorderSide!
                ? BorderSide(
                    color: Color(borderColor),
                    width: style!.borderWidth!,
                  )
                : BorderSide.none,
          );
  }
}
