import 'package:app_template/common/component/button/basic_elevated_button.dart';
import 'package:app_template/common/component/button/primary_elevated_button.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';


class DialogUtil {

  static Widget buildAlertDialog({
    String? title,
    required String content,
    List<Widget>? actions,
  }) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
      ),
      title: title != null
        ? Center(
            child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: BODY_TEXT_COLOR_02
              ),
            ),
          )
        : null,
      content: Text(content),
      actions: actions,
    );
  }

  /// Single Confirm
  static void showSingleConfirm(BuildContext context, {
    String? title,
    required String content,
    required String confirmText,
    required VoidCallback confirmCallBack,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return buildAlertDialog(
            title: title,
            content: content,
            actions: [
              Row(
                children: [
                  Expanded(
                      child: PrimaryElevatedButton(
                        title: confirmText,
                        callback: confirmCallBack,
                      )
                  )
                ],
              )
            ],
          );
        }
    );
  }

  /// Double Confirm
  static void showDoubleConfirm(BuildContext context, {
    String? title,
    required String content,
    required String confirmText,
    required String cancelText,
    required VoidCallback confirmCallBack,
    required VoidCallback cancelCallBack,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return buildAlertDialog(
            title: title,
            content: content,
            actions: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: BasicElevatedButton(
                        title: cancelText,
                        callback: cancelCallBack,
                      )
                  ),
                  SizedBox(width: 12.0,),
                  Expanded(
                      child: PrimaryElevatedButton(
                        title: confirmText,
                        callback: confirmCallBack,
                      )
                  )
                ],
              )
            ],
          );
        }
    );
  }
}