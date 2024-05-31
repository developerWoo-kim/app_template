
import 'package:app_template/common/component/modal/basic_modal_bottom_sheet.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/const/radius_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomModalSheetUtil {
  static void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget content,
    bool showModalBar = false,
    RadiusType radiusType = RadiusType.NONE,
  }) {
    showModalBottomSheet(
      backgroundColor: PRIMARY_COLOR_04,
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter bottomState) {
          return BasicModalBottomSheet(
            content: content,
            showModalBar: showModalBar,
            radiusType: radiusType,
          );
        }
        );
      },
    );
  }

}