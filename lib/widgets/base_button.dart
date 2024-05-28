import 'package:ds250/core/app_export.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  BaseButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.buttonStyle,
    this.buttonTextStyle,
    this.buttonMainAxisAlignment,
    this.isDisabled,
    this.height,
    this.width,
    this.margin,
    this.alignment,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.loadingIcon,
  }) : super(
          key: key,
        );

  final String text;

  final VoidCallback? onPressed;

  final ButtonStyle? buttonStyle;

  final TextStyle? buttonTextStyle;

  final bool? isDisabled;

  final double? height;

  final double? width;

  final EdgeInsets? margin;

  final Alignment? alignment;

  final MainAxisAlignment? buttonMainAxisAlignment;

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final Widget? loadingIcon;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
