import 'package:app_template/common/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/text/title_text.dart';

enum AppBarType {
  TEXT_TITLE,
  MAP_TAB_BAR,
  MAP_SEARCH_BAR,
}

class AppBarUtil {

  static AppBar buildAppBar(AppBarType type, {
    String? title,
  }) {
    final borderStyle = OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: BODY_TEXT_COLOR5)
    );

    switch (type) {
      case AppBarType.TEXT_TITLE:
        return AppBar(
          title: TitleText(title: title!),
        );
      case AppBarType.MAP_TAB_BAR:
        return AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: '주소보기',),
              Tab(text: '목록보기',)
            ],
          ),
        );
      default:
        throw ArgumentError('Invalid widget type');
    }
  }
}