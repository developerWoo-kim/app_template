import 'package:app_template/common/component/bottom_navigation/basic_bottom_navigation_bar.dart';
import 'package:app_template/common/component/button/custom_elevated_button.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/const/radius_type.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/common/utils/cupertino_modal_util.dart';
import 'package:app_template/template/sample/adruck/ad_driving_option_provider.dart';
import 'package:app_template/template/sample/adruck/driving_end_option_setting_screen.dart';
import 'package:app_template/template/sample/adruck/driving_option_model.dart';
import 'package:app_template/template/sample/adruck/driving_start_option_setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoDrivingOptionSettingScreen extends ConsumerStatefulWidget {
  const AutoDrivingOptionSettingScreen({super.key});

  @override
  ConsumerState<AutoDrivingOptionSettingScreen> createState() => _AutoDrivingOptionSettingScreenState();

}

class _AutoDrivingOptionSettingScreenState extends ConsumerState<AutoDrivingOptionSettingScreen> {
  static const auto_driving_option_channel = MethodChannel('auto_driving_option_channel');

  Future<void> saveAutoDrivingOption() async {

    final state = ref.read(adDrivingOptionProvider);
    final model = state as DrivingOptionModel;
    try {
      await auto_driving_option_channel.invokeMethod('setOption', {
        'autoStartType' : model.autoStartType.code,
        'beaconAddress' : 'C3:00:00:2D:DA:69',
        'drivingStartCondition' : model.drivingStartCondition.value,
        'drivingEndCondition' : model.drivingEndCondition.value,
      });

      ref.read(saveAdDrivingOptionProvider.notifier).saveAdDrivingOption(model);

      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      // 에러 처리
      print("Failed to invoke method: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adDrivingOptionProvider);
    if(state is DrivingOptionModelLoading) {
      return DefaultLayout(
        appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE, title: '자동운행기록 설정'),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Center(
            child: CircularProgressIndicator(),
          )
        ),
      );
    }

    final model = state as DrivingOptionModel;
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE, title: '자동운행기록 설정'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ListView(
          children: [
            _autoDrivingSettingRow(model),
            if(model.autoStartType != AutoStartType.NONE)
            _autoDrivingDetailSetting(model)
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

  Widget _autoDrivingSettingRow(DrivingOptionModel model) {
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
                            ref.read(adDrivingOptionProvider.notifier).copyWith(autoStartType: AutoStartType.BATTERY);
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
                            ref.read(adDrivingOptionProvider.notifier).copyWith(autoStartType: AutoStartType.BEACON);
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
                            ref.read(adDrivingOptionProvider.notifier).copyWith(autoStartType: AutoStartType.NONE);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ]
                );
              },
              child: _autoDrivingSettingText(model)
          ),
        ),
        const Divider(thickness: 1, height: 1),
        SizedBox(height: 16.0,)
      ],
    );
  }

  Widget _autoDrivingSettingText(DrivingOptionModel model) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          model.autoStartType.icon,
          SizedBox(width: 8),// 아이콘과 텍스트 간의 간격
          BodyText(
              title: model.autoStartType.value,
              textSize: BodyTextSize.MEDIUM
          ),
          Spacer(), // 오른쪽 여백 확장
          Icon(Icons.chevron_right, color: PRIMARY_COLOR_06,) // 꺽새 아이콘
        ],
      ),
    );
  }
  
  Widget _autoDrivingDetailSetting(DrivingOptionModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0,),
        BodyText(title: '상세설정', textSize: BodyTextSize.LARGE, fontWeight: FontWeight.w500,),
        Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DrivingStartOptionSettingScreen(),
                  ),
                );
              },
              child: _autoDrivingDetailSettingText(text: '운행시작 조건', value: model.drivingStartCondition.textValue.toString())
          ),
        ),
        const Divider(thickness: 1, height: 1),
        const SizedBox(height: 6,),
        Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DrivingEndOptionSettingScreen(),
                  ),
                );
              },
              child: _autoDrivingDetailSettingText(text: '운행종료 조건', value: model.drivingEndCondition.textValue.toString())
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
