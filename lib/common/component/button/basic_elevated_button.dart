import 'package:app_template/common/component/button/enum/round_degree.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

class BasicElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  const BasicElevatedButton({
    required this.title,
    required this.callback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: BODY_TEXT_COLOR4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoundDegree.HIGH.value),
          ),
        ),
        onPressed: callback,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black
          ),
        )
    );
  }
}
