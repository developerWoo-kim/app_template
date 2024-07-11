import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/component/text/body_text_box.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/template/sample/adruck/auto_driving_option_setting_screen.dart';
import 'package:flutter/material.dart';

class AdDrivingScreen extends StatefulWidget {
  const AdDrivingScreen({super.key});

  @override
  State<AdDrivingScreen> createState() => _AdDrivingScreenState();
}

class _AdDrivingScreenState extends State<AdDrivingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE, title: '광고운행'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: ListView(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AutoDrivingOptionSettingScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR_07,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('자동운행기록설정'),
                            Text('미설정'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.do_not_disturb_alt, color: Colors.red),
                                SizedBox(width: 10,),
                                Text('data')
                              ],
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
            SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BodyTextBox(
                  title: '진행중인광고',
                  textColor: PRIMARY_COLOR_04,
                  boxColor: PRIMARY_COLOR_03,
                  borderCircular: 15,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BodyText(
                  title: '애드럭 프로모션 광고기사 모집',
                  textSize: BodyTextSize.LARGE,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR_01,
                      shape: BoxShape.circle

                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BodyText(
                        title: '광고운행',
                        textSize: BodyTextSize.MEDIUM,
                        color: BODY_TEXT_COLOR_01,
                      ),
                      Text('시작',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 38,
                          color: BODY_TEXT_COLOR_01
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
