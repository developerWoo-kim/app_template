
import 'package:app_template/common/component/text/body_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoModalUtil {

  static void showCustomCupertinoModal(BuildContext context, {
    required String title,
    required List<Widget> actions
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: BodyText(
              title: title,
              textSize: BodyTextSize.MEDIUM
          ),
          actions: actions,
          cancelButton: CupertinoActionSheetAction(
            child: BodyText(
              title: '취소',
              textSize: BodyTextSize.MEDIUM,
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }
}