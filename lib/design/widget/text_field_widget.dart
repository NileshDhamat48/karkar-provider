import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.hintText,
    this.label,
    this.icon,
    this.autofocus = false,
    this.enabled,
    this.readOnly = false,
    this.initialValue,
    required this.controller,
    required this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.suffixIcon,
    this.hintStyle,
    this.style,
    this.labelStyle,
    this.maxLines,
    this.maxLength,
    this.minLines,
    this.onChanged,
    this.onFieldSubmitted,
    this.customBorder,
    this.fillColor,
    this.contentPadding,
    this.filled = false,
    this.textInputAction,
    this.onTap,
    required this.focusNode,
    required this.padding,
    this.inputFormatters,
    this.textFieldLable,
  }) : super(key: key);
  final String hintText;
  final String? label;
  final IconData? icon;
  final bool autofocus;
  final bool? enabled;
  final bool readOnly;
  final String? initialValue;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final InputBorder? customBorder;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool? filled;
  final TextInputAction? textInputAction;
  final FocusNode focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? textFieldLable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.tranparentColor,
        padding: padding,
        child: Column(
          children: [
            if (label != null && label != '')
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      label!,
                      style: labelStyle ??
                          const TextStyle(
                            color: AppColors.greyColor,
                          ),
                    ),
                    if (icon != null)
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 25,
                        ),
                      ),
                  ],
                ),
              ),
            TextFormField(
              initialValue: initialValue,
              autofocus: autofocus,
              inputFormatters: inputFormatters,
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              maxLength: maxLength,
              keyboardType: keyboardType,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              readOnly: readOnly,
              textCapitalization: textCapitalization,
              maxLines: maxLines,
              textInputAction: textInputAction,
              minLines: minLines,
              style: const TextStyle(
                color: AppColors.whiteColor,
              ),
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                alignLabelWithHint: true,
                suffixIcon: suffixIcon,
                hintText: hintText,
                labelStyle: labelStyle,
                fillColor: fillColor,
                filled: filled,
                counterText: '',
                label: textFieldLable != null ? Text(textFieldLable!) : null,
                border: customBorder ?? Theme.of(context).inputDecorationTheme.border,
                enabledBorder: customBorder ??
                    UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.greyColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                errorBorder: customBorder ?? Theme.of(context).inputDecorationTheme.border,
                focusedBorder: customBorder ?? Theme.of(context).inputDecorationTheme.focusedBorder,
                disabledBorder: customBorder ??
                    UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.greyColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                focusedErrorBorder: customBorder ?? Theme.of(context).inputDecorationTheme.border,
                hintStyle: hintStyle ??
                    const TextStyle(
                      color: AppColors.whiteColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
