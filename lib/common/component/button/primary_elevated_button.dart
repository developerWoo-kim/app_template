import 'package:app_template/common/component/button/enum/round_degree.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

class PrimaryElevatedButton extends StatelessWidget {
  final String title;
  final RoundDegree? roundDegree;
  final VoidCallback callback;

  const PrimaryElevatedButton({
    required this.title,
    this.roundDegree,
    required this.callback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR_01,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roundDegree != null ? roundDegree!.value : RoundDegree.NONE.value),
            )
        ),
        onPressed: callback,
        child: BodyText(
          title: title,
          textSize: BodyTextSize.MEDIUM,
          color: BODY_TEXT_COLOR_03,
          fontWeight: FontWeight.w500,
        )
    );
  }
}
