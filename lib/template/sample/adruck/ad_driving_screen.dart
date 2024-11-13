import 'dart:async';
import 'dart:ffi';

import 'package:app_template/app/user/model/user_model.dart';
import 'package:app_template/app/user/provider/auth_provider.dart';
import 'package:app_template/app/user/provider/user_provider.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/component/text/body_text_box.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/const/custom_method_channel.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/common/utils/dialog_util.dart';
import 'package:app_template/common/utils/permission_util.dart';
import 'package:app_template/template/sample/adruck/ad_driving_option_provider.dart';
import 'package:app_template/template/sample/adruck/auto_driving_option_setting_screen.dart';
import 'package:app_template/template/sample/adruck/driving_option_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdDrivingScreen extends ConsumerStatefulWidget {
  static String get routeName => 'adDriveScreen';
  const AdDrivingScreen({super.key});

  @override
  ConsumerState<AdDrivingScreen> createState() => _AdDrivingScreenState();
}

class _AdDrivingScreenState extends ConsumerState<AdDrivingScreen> {
  int second = 0;
  bool isDriving = false;
  String drivingTime = '00:00:00';

  @override
  void initState() {
    super.initState();
    CustomMethodChannel.timer_event_channel.receiveBroadcastStream().listen((event) {
      final Map<dynamic, dynamic> result = event;
      int drivingMs = result['time'] as int;
      bool isRunning = result['isRunning'] as bool;

      // Duration 객체 생성
      Duration duration = Duration(milliseconds: drivingMs);

      setState(() {
        drivingTime = _formatDuration(duration);
      });

      if(isDriving != isRunning) {
        setState(() {
          isDriving = isRunning;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    // 두 자리 숫자 형식으로 시간, 분, 초 변환
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    // 시간, 분, 초 추출
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: _DrivingAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 8, top: 2, right: 8, bottom: 10),
        child: ListView(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDriving
                ? () {
                  DialogUtil.showSingleConfirm(context,
                      content: '운행중에는 설정할 수 없습니다.',
                      confirmText: '확인',
                      confirmCallBack: () {
                        context.pop();
                      }
                  );
                }
                : () async {
                  var locationAccess = await PermissionUtil.location();
                  if(!locationAccess) {
                    DialogUtil.showSingleConfirm(context,
                        content: '위치권한을 항상허용으로 설정해야 자동운행 설정이 가능합니다.',
                        confirmText: '확인',
                        confirmCallBack: () {
                          context.pop();
                        }
                    );
                  }

                  var locationAlwaysAccess = await PermissionUtil.locationAlways();
                  if(!locationAlwaysAccess) {
                    DialogUtil.showSingleConfirm(context,
                        content: '위치권한을 항상허용으로 설정해야 자동운행 설정이 가능합니다.',
                        confirmText: '확인',
                        confirmCallBack: () {
                          context.pop();
                        }
                    );
                  }

                  var notificationAccess = await PermissionUtil.notification();
                  if(!notificationAccess) {
                    DialogUtil.showSingleConfirm(context,
                        content: '알림설정을 허용해야 자동운행 설정이 가능합니다.',
                        confirmText: '확인',
                        confirmCallBack: () {
                          context.pop();
                        }
                    );
                  }

                  if(locationAccess && locationAlwaysAccess && notificationAccess) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AutoDrivingOptionSettingScreen(),
                      ),
                    );
                  }
                },
                child: _AutoDrivingOption()
              )
            ),
            SizedBox(height: 24.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BodyTextBox(
                  title: '진행중인광고',
                  textColor: PRIMARY_COLOR_05,
                  boxColor: BODY_COLOR5,
                  borderCircular: 15,
                )
              ],
            ),
            SizedBox(height: 6.0,),
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
            SizedBox(height: 70.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    final state = ref.read(saveAdDrivingOptionProvider);

                    final model = state as DrivingOptionModel;
                    if(model.autoStartType != AutoStartType.NONE) {
                      DialogUtil.showSingleConfirm(context,
                          content: '자동운행 사용 중에는 사용 하실 수 없습니다.',
                          confirmText: '확인',
                          confirmCallBack: () {
                            context.pop();
                          }
                      );
                    } else {

                    }

                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.42,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                        color: isDriving ? Colors.red : PRIMARY_COLOR_01,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(isDriving)
                        BodyText(
                          title: drivingTime,
                          textSize: BodyTextSize.MEDIUM,
                          color: BODY_TEXT_COLOR_01,
                        ),
                        // BodyText(
                        //   title: '광고운행',
                        //   textSize: BodyTextSize.LARGE,
                        //   color: BODY_TEXT_COLOR_01,
                        // ),
                        Text('광고운행',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: BODY_TEXT_COLOR_01
                          ),
                        ),
                        Text(isDriving ? '종료' : '시작',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 42,
                              color: BODY_TEXT_COLOR_01
                          ),
                        )
                        // BodyText(
                        //   title: '광고운행',
                        //   textSize: BodyTextSize.LARGE,
                        //   color: BODY_TEXT_COLOR_01,
                        // ),
                        // Text('시작',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 38,
                        //     color: BODY_TEXT_COLOR_01
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 60,),
            BodyText(
              title: '누적운행정보',
              textSize: BodyTextSize.LARGE,
              fontWeight: FontWeight.w500,
            ),
            _DrivingGuide()
          ],
        ),
      ),
    );
  }

  AppBar? _DrivingAppBar() {
    final state = ref.watch(userProvider);

    if(state is! UserModel) {
      return AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE);
    } else {
      final user = state;

      return AppBarUtil.buildAppBar(AppBarType.DRIVE_SCREEN_APP_BAR,
        title: '로그인 계정 : ${user.userId}',
        callBack: () {
          ref.read(authProvider).logout();
        }
      );
    }
  }

  Widget _AutoDrivingOption() {
    final state = ref.watch(saveAdDrivingOptionProvider);
    if(state is DrivingOptionModelLoading) {
      return Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final model = state as DrivingOptionModel;
    return Container(
      decoration: BoxDecoration(
          color: BODY_COLOR4,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyTextBox(
                  title: '자동운행기록설정',
                  textColor: PRIMARY_COLOR_05,
                  boxColor: BODY_COLOR5,
                  borderCircular: 15,
                ),
                BodyTextBox(
                  title: model.autoStartType == AutoStartType.NONE ? '미설정' : '사용중',
                  textColor: PRIMARY_COLOR_04,
                  boxColor: model.autoStartType == AutoStartType.NONE ? Colors.red : BODY_TEXT_COLOR_GREEN_02,
                  borderCircular: 15,
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    model.autoStartType.icon,
                    SizedBox(width: 10,),
                    BodyText(
                      title: model.autoStartType.value,
                      textSize: BodyTextSize.MEDIUM,
                      fontWeight: FontWeight.w500,
                    )
                    // Text(model.autoStartType.value)
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _DrivingGuide() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
          color: BODY_COLOR4,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}
