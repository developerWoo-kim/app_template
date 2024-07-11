import 'package:app_template/common/component/bottom_navigation/basic_bottom_navigation_bar.dart';
import 'package:app_template/common/component/button/custom_elevated_button.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/const/radius_type.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/common/utils/cupertino_modal_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AutoStartType {
  NONE('사용 안함', Icon(Icons.do_not_disturb_alt, color: Colors.red, size: 25,), 'none'),
  BATTERY('배터리 충전 시', Icon(Icons.battery_charging_full, color: BATTERY_COLOR, size: 25,), 'battery'),
  BEACON('BLE 비콘 연결 시', Icon(Icons.bluetooth, color: BLUETOOTH_COLOR, size: 25,), 'beacon');

  const AutoStartType(this.value, this.icon, this.code);

  final String value;
  final Icon icon;
  final String code;
}

enum DrivingStartCondition {
  IMMEDIATE('즉시운행', ''),
  DETECT_10('10km/h', '10'),
  DETECT_15('15km/h', '15'),
  DETECT_20('20km/h', '20');
  const DrivingStartCondition(this.textValue, this.value);

  final String textValue;
  final String value;
}

enum DrivingEndCondition {
  IMMEDIATE('즉시종료', ''),
  SEC_30('30초', '30'),
  MIN_1('1분', '60'),
  MIN_3('3분', '180'),
  MIN_5('5분', '300');

  const DrivingEndCondition(this.textValue, this.value);

  final String textValue;
  final String value;
}

class AutoDrivingOptionSettingScreen extends ConsumerStatefulWidget {
  const AutoDrivingOptionSettingScreen({super.key});

  @override
  ConsumerState<AutoDrivingOptionSettingScreen> createState() => _AutoDrivingOptionSettingScreenState();
}

class _AutoDrivingOptionSettingScreenState extends ConsumerState<AutoDrivingOptionSettingScreen> {
  AutoStartType autoStartType = AutoStartType.NONE;
  String beaconAddress = 'C3:00:00:2D:DA:69';
  DrivingStartCondition drivingStartCondition = DrivingStartCondition.DETECT_10;
  DrivingEndCondition drivingEndCondition = DrivingEndCondition.IMMEDIATE;

  static const auto_driving_option_channel = MethodChannel('auto_driving_option_channel');

  Future<void> saveAutoDrivingOption() async {
    try {
      await auto_driving_option_channel.invokeMethod('setOption', {
        'autoStartType' : autoStartType.code,
        'beaconAddress' : beaconAddress,
        'drivingStartCondition' : drivingStartCondition.value,
        'drivingEndCondition' : drivingEndCondition.value,
      });
    } on PlatformException catch (e) {
      // 에러 처리
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE, title: '자동운행기록 설정11'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ListView(
          children: [
            _autoDrivingSettingRow(),
            if(autoStartType != AutoStartType.NONE)
            _autoDrivingDetailSetting()
          ],
        ),
      ),
      bottomNavigationBar: BasicBottomNavigationBar(
        backgroundColor: PRIMARY_COLOR_04,
        content: Row(
          children: [
            Expanded(
                child: CustomElevatedButton(
                  title: '저장',
                  backgroundColor: PRIMARY_COLOR_03,
                  textColor: BODY_TEXT_COLOR_01,
                  callback: () async{
                    saveAutoDrivingOption();
                  },
                )
            )
          ],
        ),
      )
    );
  }

  Widget _autoDrivingSettingRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(title: '자동운행기록 방식 선택', textSize: BodyTextSize.LARGE, fontWeight: FontWeight.w500,),
        Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: (){
                CupertinoModalUtil.showCustomCupertinoModal(
                    context,
                    title: '자동 운행 선택',
                    actions: [
                      CupertinoActionSheetAction(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoStartType.BATTERY.icon,
                              const SizedBox(width: 10,),
                              BodyText(
                                title: AutoStartType.BATTERY.value,
                                textSize: BodyTextSize.MEDIUM,
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            autoStartType = AutoStartType.BATTERY;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoStartType.BEACON.icon,
                              const SizedBox(width: 10,),
                              BodyText(
                                title: AutoStartType.BEACON.value,
                                textSize: BodyTextSize.MEDIUM,
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            autoStartType = AutoStartType.BEACON;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoStartType.NONE.icon,
                              const SizedBox(width: 10,),
                              BodyText(
                                title: AutoStartType.NONE.value,
                                textSize: BodyTextSize.MEDIUM,
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            autoStartType = AutoStartType.NONE;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ]
                );
              },
              child: _autoDrivingSettingText()
          ),
        ),
        const Divider(thickness: 1, height: 1),
        SizedBox(height: 16.0,)
      ],
    );
  }

  Widget _autoDrivingSettingText() {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          autoStartType.icon,
          SizedBox(width: 8),// 아이콘과 텍스트 간의 간격
          BodyText(
              title: autoStartType.value,
              textSize: BodyTextSize.MEDIUM
          ),
          Spacer(), // 오른쪽 여백 확장
          Icon(Icons.chevron_right, color: PRIMARY_COLOR_06,) // 꺽새 아이콘
        ],
      ),
    );
  }
  
  Widget _autoDrivingDetailSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(title: '상세설정', textSize: BodyTextSize.LARGE, fontWeight: FontWeight.w500,),
        Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: (){
              },
              child: _autoDrivingDetailSettingText(text: '운행시작 조건', value: drivingStartCondition.textValue.toString())
          ),
        ),
        const Divider(thickness: 1, height: 1),
        const SizedBox(height: 6,),
        Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: (){
              },
              child: _autoDrivingDetailSettingText(text: '운행종료 조건', value: drivingEndCondition.textValue.toString())
          ),
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }

  Widget _autoDrivingDetailSettingText({
    required String text,
    required String value
}) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          BodyText(
              title: text,
              textSize: BodyTextSize.MEDIUM
          ),
          Spacer(), // 오른쪽 여백 확장
          BodyText(
              title: value,
              textSize: BodyTextSize.REGULAR,
              color: PRIMARY_COLOR_03,
          ),
          Icon(Icons.chevron_right, color: PRIMARY_COLOR_06,) // 꺽새 아이콘
        ],
      ),
    );
  }

}
