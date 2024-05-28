import 'package:ds250/core/app_export.dart';
import 'package:ds250/widgets/base_button.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    Widget? leftIcon,
    Widget? rightIcon,
    Widget? loadingIcon,
    BoxDecoration? decoration,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    MainAxisAlignment? buttonMainAxisAlignment,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
      text: text,
      onPressed: onPressed,
      buttonStyle: buttonStyle,
      isDisabled: isDisabled,
      buttonMainAxisAlignment: buttonMainAxisAlignment,
      buttonTextStyle: buttonTextStyle,
      height: height,
      width: width,
      alignment: alignment,
      margin: margin,
      leftIcon: leftIcon,
      loadingIcon: loadingIcon,
      rightIcon: rightIcon,
      decoration: decoration
  );



  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: buildElevatedButtonWidget,
    )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
    height: this.height ?? 57.h,
    width: this.width ?? double.maxFinite,
    margin: margin,
    decoration: decoration,
    child: ElevatedButton(
      style: buttonStyle,
      onPressed: isDisabled ?? false ? null : onPressed ?? () {},
      child: Row(
        mainAxisAlignment: buttonMainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leftIcon ?? const SizedBox.shrink(),
          loadingIcon != null ? loadingIcon! : Text(
            text,
            style: buttonTextStyle ??
                CustomTextStyles.titleSmallOnPrimaryContainer_1,
          ),
          rightIcon ?? const SizedBox.shrink(),
        ],
      ),
    ),
  );
}