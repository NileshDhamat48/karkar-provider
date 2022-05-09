import 'package:flutter/material.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onPressed,
    this.text,
    this.height,
    this.maxWidth,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final Text? text;
  final double? height;
  final double? maxWidth;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: text,
      ),
      splashColor: AppColors.commonButtonSplashColor,
      fillColor: backgroundColor ?? AppColors.red,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(99999)),
      textStyle: Theme.of(context).textTheme.button!.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 2.5,
          ),
      constraints: BoxConstraints(
        minHeight: height ?? 50.0,
        maxWidth: maxWidth ?? Size.infinite.width,
      ),
    );
  }
}
