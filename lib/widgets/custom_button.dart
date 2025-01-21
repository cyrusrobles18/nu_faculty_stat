import 'package:faculty_stat_monitoring/constants.dart';
import 'package:faculty_stat_monitoring/widgets/custom_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final onTap;
  final double height;
  final double width;
  final double fontSize;
  final String buttonName;
  final Icon icon;
  FontWeight fontWeight;
  Color bgColor;
  Color fontColor;
  CustomButton(
      {super.key,
      required this.onTap,
      required this.height,
      required this.width,
      this.buttonName = '',
      this.bgColor = NU_BLUE,
      this.fontColor = Colors.white,
      this.fontSize = 1,
      this.icon = const Icon(null),
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: buttonName == ''
              ? icon
              : CustomText(
                  text: buttonName, fontSize: fontSize, color: fontColor),
        ),
      ),
    );
  }
}
