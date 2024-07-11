import 'package:app_template/common/component/bottom_navigation/basic_bottom_navigation_bar.dart';
import 'package:app_template/common/component/button/custom_elevated_button.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/const/radius_type.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarScreen extends StatelessWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE, title: 'BottomNavigationBar'),
      body: Container(),
      bottomNavigationBar: BasicBottomNavigationBar(
        backgroundColor: PRIMARY_COLOR_05,
        content: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(
                    title: '총 주문금액',
                    textSize: BodyTextSize.MEDIUM,
                    color: BODY_TEXT_COLOR_01,
                  ),
                  BodyText(
                    title: '260,000원',
                    textSize: BodyTextSize.LARGE,
                    color: BODY_TEXT_COLOR_GREEN_01,
                    fontWeight: FontWeight.w500,
                  ),
                  ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    title: '주문하기',
                    roundDegree: RadiusType.HIGH,
                    backgroundColor: PRIMARY_COLOR_01,
                    textColor: BODY_TEXT_COLOR_01,
                    callback: (){},
                  )
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
