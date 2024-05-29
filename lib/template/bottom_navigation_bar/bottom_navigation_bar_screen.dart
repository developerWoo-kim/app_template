import 'package:app_template/common/component/bottom_navigation/basic_bottom_navigation_bar.dart';
import 'package:app_template/common/component/button/enum/round_degree.dart';
import 'package:app_template/common/component/button/primary_elevated_button.dart';
import 'package:app_template/common/const/colors.dart';
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
        content: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('111'),
                  Text('111', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: PrimaryElevatedButton(
                    title: '버튼',
                    roundDegree: RoundDegree.HIGH,
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
