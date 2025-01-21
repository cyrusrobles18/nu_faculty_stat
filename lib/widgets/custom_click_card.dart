import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';

class CustomClickCard extends StatelessWidget {
  final double height;
  final double width;
  final double fontSize;
  final Icon icon;
  final String text;
  final Color cardColor;
  final Color fontColor;
  final onTap;
  const CustomClickCard({
    super.key,
    required this.height,
    required this.width,
    this.icon = const Icon(Icons.person),
    required this.text,
    required this.cardColor,
    required this.fontColor,
    required this.fontSize, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
        onTap: onTap,
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: ScreenUtil().setHeight(5)),
              CustomText(
                text: text,
                fontSize: fontSize,
                color: fontColor,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
        ),
      ),
    );
  }
}
