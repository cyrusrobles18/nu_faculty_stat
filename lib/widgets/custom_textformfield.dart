// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:faculty_stat_monitoring/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.validator,
    required this.onSaved,
    this.controller = TextEditingController,
    this.isObscure = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = Colors.black12,
    required this.height,
    required this.width,
  });

  final validator;
  final onSaved;
  final controller;
  final isObscure;
  final fontSize;
  final fontColor;
  final double height, width;
  final hintTextSize;
  final hintText;
  final fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontFamily: 'Mazzard'
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(width, height, width, height),
          focusColor: Colors.black12,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: NU_BLUE,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: STAT_RED_OUT,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          errorStyle: const TextStyle(fontFamily: 'Mazzard'),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: STAT_RED_OUT,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: NU_YELLOW,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          filled: true,
          hintStyle: TextStyle(
            color: Colors.black12,
            fontSize: hintTextSize,
            fontFamily: 'Mazzard',
          ),
          hintText: hintText,
          fillColor: fillColor),
    );
  }
}
