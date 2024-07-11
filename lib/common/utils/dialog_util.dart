import 'package:app_template/common/component/button/custom_elevated_button.dart';
import 'package:app_template/common/component/text/body_text.dart';
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
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BodyText(
                title: title,
                textSize: BodyTextSize.LARGE,
                fontWeight: FontWeight.w500,
              ),
            ],
          )
        : null,
      content: BodyText(
        title: content,
        textSize: BodyTextSize.MEDIUM,
      ),
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
                      child: CustomElevatedButton(
                        title: confirmText,
                        backgroundColor: PRIMARY_COLOR_01,
                        textColor: BODY_TEXT_COLOR_01,
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
                      child: CustomElevatedButton(
                        title: cancelText,
                        backgroundColor: PRIMARY_COLOR_04,
                        textColor: BODY_TEXT_COLOR_02,
                        callback: cancelCallBack,
                      )
                  ),
                  const SizedBox(width: 12.0,),
                  Expanded(
                      child: CustomElevatedButton(
                        title: confirmText,
                        backgroundColor: PRIMARY_COLOR_01,
                        textColor: BODY_TEXT_COLOR_01,
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