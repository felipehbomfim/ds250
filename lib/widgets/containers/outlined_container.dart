import 'package:flutter/material.dart';
import 'package:ds250/core/app_export.dart';

class OutlinedContainer extends StatelessWidget {
  OutlinedContainer({
    Key? key,
    this.title,
    this.subtitle,
    this.color,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.containerPadding,
  }) : super(
    key: key,
  );

  final String? title;

  final String? subtitle;

  final Color? color;

  final TextStyle? titleTextStyle;

  final TextStyle? subtitleTextStyle;

  final EdgeInsets? containerPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: color ?? Colors.white
          )
      ),
      padding: containerPadding ?? EdgeInsets.symmetric(
        horizontal: 18.h,
        vertical: 5.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(title != null)
            Text(title ?? "", maxLines: 1, style: titleTextStyle ?? theme.textTheme.bodyLarge),
          if(subtitle != null)
            Text(subtitle ?? "", style: subtitleTextStyle ?? theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
