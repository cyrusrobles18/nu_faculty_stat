import 'package:faculty_stat_monitoring/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_pulse_icon.dart';

void showConfirmDialog(BuildContext context, String title, String message,
    VoidCallback onConfirm) {
  AlertDialog alert = AlertDialog(
    title: Row(
      children: [
        CustomPulseIcon(),
        const SizedBox(width: 10),
        CustomText(
          text: title,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(12),
        ),
      ],
    ),
    content: CustomText(text: message, fontSize: ScreenUtil().setSp(8)),
    actions: [
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: CustomText(text: 'Cancel', fontSize: ScreenUtil().setSp(8)),
      ),
      ElevatedButton(
        onPressed: () {
          onConfirm();
          Navigator.pop(context);
        },
        child: CustomText(text: 'Confirm', fontSize: ScreenUtil().setSp(8)),
      ),
    ],
  );

  showDialog(
    barrierDismissible: false, // Prevent dismissing by tapping outside
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


void showLoadingDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Row(
      children: [
        CustomPulseIcon(),
        const SizedBox(width: 10),
        CustomText(
          text: 'Please wait for a while',
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(12),
        ),
      ],
    ),
  );

  showDialog(
    barrierDismissible: false, // Prevent dismissing by tapping outside
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}