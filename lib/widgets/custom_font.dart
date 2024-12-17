import 'package:flutter/material.dart';

class CustomFont extends StatelessWidget {
  const CustomFont(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.color,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.left,
      this.letterSpacing = 0,
      this.fontFamily = 'Mazzard'});

  final String text;
  final double fontSize, letterSpacing;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
      softWrap: false,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing),
    );
  }
}
