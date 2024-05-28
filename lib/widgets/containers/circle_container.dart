import 'package:flutter/material.dart';
import 'package:ds250/core/app_export.dart';

class CircleContainer extends StatelessWidget {
  CircleContainer({
    Key? key,
    required this.text,
    required this.fontSize,
    this.containerPadding,
    this.firstColorGradient = Colors.lightGreen,
    this.secondColorGradient = Colors.green,
    this.textColor = Colors.white,
  }) : super(
    key: key,
  );

  final String text;
  final double fontSize;
  final EdgeInsets? containerPadding;
  final Color firstColorGradient;
  final Color secondColorGradient;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: containerPadding ?? EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [firstColorGradient, secondColorGradient],
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
