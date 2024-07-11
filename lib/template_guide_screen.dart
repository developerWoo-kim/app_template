import 'package:app_template/common/component/button/custom_elevated_button.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/utils/bottom_modal_sheet_util.dart';
import 'package:app_template/common/utils/dialog_util.dart';
import 'package:app_template/template/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:app_template/template/modal_bottom_sheet/draggable_modal_bottom_sheet_screen.dart';
import 'package:app_template/template/naver_map/naver_map_template_screen.dart';
import 'package:app_template/template/sample/adruck/ad_driving_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'template/sample/adruck/auto_driving_option_setting_screen.dart';

class TemplateGuideScreen extends StatelessWidget {
  const TemplateGuideScreen({super.key});

  Future<bool> _checkBlePermission() async {
    final access = Permission.bluetoothScan.request();
    return true;
  }
  Future<bool> _checkLocationPermission() async {
    final access = await Permission.location.status;
    debugPrint('Access ::: ${access.name}');
    switch (access) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        var result = await Permission.locationWhenInUse.request();
        debugPrint('Result ::: ${result.name}');
        if(result.isDenied || result.isPermanentlyDenied) {
          return false;
        }
        return true;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        return false;
      case PermissionStatus.granted:
        var result = await Permission.locationWhenInUse.request();
        debugPrint('Result ::: ${result.name}');
        if(result.isDenied || result.isPermanentlyDenied) {
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('Dialog',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showSingleConfirm(context,
                      content: 'showNoTitleSingleConfirm',
                      confirmText: '확인',
                      confirmCallBack: (){Navigator.of(context).pop();},
                    );
                  },
                  child: Text('No Title + Single Confirm'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showSingleConfirm(context,
                      title: 'showTitleSingleConfirm',
                      content: 'showTitleSingleConfirm',
                      confirmText: '확인',
                      confirmCallBack: (){Navigator.of(context).pop();},
                    );
                  },
                  child: Text('Title + Single Confirm'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showDoubleConfirm(context,
                      content: 'noTitleDoubleConfirm',
                      confirmText: '확인',
                      cancelText: '취소',
                      confirmCallBack: (){},
                      cancelCallBack: (){Navigator.of(context).pop();}
                    );
                  },
                  child: Text('No Title + Double Confirm'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showDoubleConfirm(context,
                        title: 'ShowTitleDoubleConfirm',
                        content: 'TitleDoubleConfirm',
                        confirmText: '확인',
                        cancelText: '취소',
                        confirmCallBack: (){},
                        cancelCallBack: (){Navigator.of(context).pop();}
                    );
                  },
                  child: Text('Title + Double Confirm'),
                ),
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('하단 네비게이션 시트',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BottomNavigationBarScreen(),
                      ),
                    );
                  },
                  child: Text('Basic BottomNavigationBar'),
                ),
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('하단 모달 시트',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    BottomModalSheetUtil.showCustomModalBottomSheet(
                        // showModalBar: true,
                        context: context,
                        content: Column(
                          children: [
                            Row(
                              children: [
                                BodyText(
                                  title: '타이틀',
                                  textSize: BodyTextSize.LARGE,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: BodyText(
                                    title: '본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.본문입니다.',
                                    textSize: BodyTextSize.REGULAR,
                                    fontWeight: FontWeight.w400,
                                  )
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomElevatedButton(
                                    title: '버튼',
                                    backgroundColor: PRIMARY_COLOR_03,
                                    textColor: BODY_TEXT_COLOR_01,
                                    callback: () {},
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                    );
                  },
                  child: Text('Basic ModalBottomSheet'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DraggableModalBottomSheetScreen(),
                      ),
                    );
                  },
                  child: Text('Draggable ModalBottomSheet'),
                ),
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('네이버 맵',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NaverMapTemplateScreen(),
                      ),
                    );
                  },
                  child: Text('Naver Map'),
                ),
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('권한',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final bleAccess = await _checkBlePermission();
                    final access = await _checkLocationPermission();

                  },
                  child: Text('권한'),
                ),
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('광고 운행(샘플)',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AdDrivingScreen(),
                      ),
                    );
                  },
                  child: Text('광고 운행'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
