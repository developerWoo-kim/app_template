import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/component/text/title_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/template/sample/adruck/ad_driving_option_provider.dart';
import 'package:app_template/template/sample/adruck/driving_option_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrivingStartOptionSettingScreen extends ConsumerStatefulWidget {
  const DrivingStartOptionSettingScreen({super.key});

  @override
  ConsumerState<DrivingStartOptionSettingScreen> createState() => _DrivingStartOptionSettingScreenState();
}

class _DrivingStartOptionSettingScreenState extends ConsumerState<DrivingStartOptionSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adDrivingOptionProvider);
    final model = state as DrivingOptionModel;
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: '${model.autoStartType.value} 후', fontWeight: FontWeight.w500,),
              TitleText(title: '운행기록 시작 조건 설정', fontWeight: FontWeight.w500,),
              SizedBox(height: 16.0,),
              Row(
                children: [
                  Icon(Icons.info_rounded, size: 20, color: BODY_TEXT_COLOR_03,),
                  SizedBox(width: 6.0,),
                  BodyText(title: '설정 속도가 낮을수록 시작 시점이 빨라집니다.', textSize: BodyTextSize.REGULAR, color: BODY_TEXT_COLOR_03)
                ],
              ),
              SizedBox(height: 16,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingStartCondition: DrivingStartCondition.IMMEDIATE);
                    },
                    child: _autoDrivingDetailSettingText(text: '${model.autoStartType.value} 후 즉시 시작', isChecked: model.drivingStartCondition.value == '')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingStartCondition: DrivingStartCondition.DETECT_10);
                    },
                    child: _autoDrivingDetailSettingText(text: '${model.autoStartType.value} 후 10km/h 감지', isChecked: model.drivingStartCondition.value == '10')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingStartCondition: DrivingStartCondition.DETECT_15);
                    },
                    child: _autoDrivingDetailSettingText(text: '${model.autoStartType.value} 후 15km/h 감지', isChecked: model.drivingStartCondition.value == '15')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingStartCondition: DrivingStartCondition.DETECT_20);
                    },
                    child: _autoDrivingDetailSettingText(text: '${model.autoStartType.value} 후 20km/h 감지', isChecked: model.drivingStartCondition.value == '20')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
            ],
          )
      ),
    );
  }

  Widget _autoDrivingDetailSettingText({
    required String text,
    required bool isChecked,
  }) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          BodyText(
              title: text,
              textSize: BodyTextSize.REGULAR
          ),
          const Spacer(), // 오른쪽 여백 확장
          if(isChecked)
          _checkOptionRow()
        ],
      ),
    );
  }

  Widget _checkOptionRow() {
    return Row(
      children: [
        BodyText(
          title: '사용중',
          textSize: BodyTextSize.REGULAR,
          color: PRIMARY_COLOR_03,
        ),
        SizedBox(width: 6.0,),
        Icon(Icons.check, color: PRIMARY_COLOR_03,),
        SizedBox(width: 6.0,),
      ],
    );
  }
}
