import 'package:app_template/common/component/text/body_text_box.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/text/title_text.dart';

enum AppBarType {
  TEXT_TITLE,
  MAP_TAB_BAR,
  MAP_SEARCH_BAR,
  DRIVE_SCREEN_APP_BAR,
  NONE,
}

class AppBarUtil {

  static AppBar? buildAppBar(AppBarType type, {
    String? title,
    VoidCallback? callBack,
  }) {
    switch (type) {
      case AppBarType.TEXT_TITLE:
        return AppBar(
          backgroundColor: PRIMARY_COLOR_04,
          title: TitleText(title: title ?? ''),
        );
      case AppBarType.MAP_TAB_BAR:
        return AppBar(
          backgroundColor: PRIMARY_COLOR_04,
          bottom: TabBar(
            tabs: [
              Tab(text: '주소보기',),
              Tab(text: '목록보기',)
            ],
          ),
        );
      case AppBarType.DRIVE_SCREEN_APP_BAR:
        return AppBar(
          backgroundColor: PRIMARY_COLOR_04,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TitleText(title: title ?? ''),
              GestureDetector(
                onTap: callBack,
                child: BodyTextBox(title: '로그아웃', textColor: PRIMARY_COLOR_04, boxColor: PRIMARY_COLOR_01,),
              )
            ],
          ),
        );
      case AppBarType.NONE:
        return null;
      default:
        return null;
    }
  }
}