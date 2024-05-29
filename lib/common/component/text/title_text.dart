import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

/// 타이틀 텍스트
class TitleText extends StatelessWidget {
  final String title;
  Color? color;
  FontWeight? fontWeight;

  TitleText({
    required this.title,
    this.color,
    this.fontWeight,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: TextStyle(
        fontSize: 20,
        color: color ?? BODY_TEXT_COLOR_02,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
    );
  }
}
