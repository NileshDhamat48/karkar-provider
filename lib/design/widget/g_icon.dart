import 'package:flutter/material.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';

class GIcon extends StatelessWidget {
  const GIcon({
    Key? key,
    required this.icon,
    this.gradient = AppColors.appGradient,
    this.onPressed,
    this.size,
  }) : super(key: key);
  final IconData? icon;
  final Gradient? gradient;
  final void Function()? onPressed;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => gradient!.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Icon(
          icon,
          size: size,
        ),
      ),
    );
  }
}
