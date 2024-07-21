import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final int maxLines;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.hintStyle,
    required this.textStyle,
    this.maxLines = 1,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: textStyle,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        border: InputBorder.none,
      ),
    );
  }
}
