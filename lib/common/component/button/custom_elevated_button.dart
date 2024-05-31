import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/const/radius_type.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final RadiusType? roundDegree;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback callback;

  const CustomElevatedButton({
    required this.title,
    this.roundDegree,
    this.backgroundColor,
    this.textColor,
    required this.callback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? PRIMARY_COLOR_01,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roundDegree != null ? roundDegree!.value : RadiusType.NONE.value),
            )
        ),
        onPressed: callback,
        child: BodyText(
          title: title,
          textSize: BodyTextSize.MEDIUM,
          color: textColor ?? BODY_TEXT_COLOR_03,
          fontWeight: FontWeight.w500,
        )
      ),
    );
  }
}
