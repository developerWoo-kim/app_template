import 'package:app_template/common/component/button/enum/round_degree.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

class BasicElevatedButton extends StatelessWidget {
  final String title;
  final RoundDegree? roundDegree;
  final VoidCallback callback;
  const BasicElevatedButton({
    required this.title,
    this.roundDegree,
    required this.callback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR_04,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundDegree != null ? roundDegree!.value : RoundDegree.NONE.value),
          ),
        ),
        onPressed: callback,
        child: BodyText(
          title: title,
          textSize: BodyTextSize.MEDIUM,
          color: BODY_TEXT_COLOR_02,
          fontWeight: FontWeight.w500,
        )
    );
  }
}
