import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/component/text/title_text.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/template/sample/adruck/ad_driving_option_provider.dart';
import 'package:app_template/template/sample/adruck/driving_option_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrivingEndOptionSettingScreen extends ConsumerStatefulWidget {
  const DrivingEndOptionSettingScreen({super.key});

  @override
  ConsumerState<DrivingEndOptionSettingScreen> createState() => _DrivingEndOptionSettingScreenState();
}

class _DrivingEndOptionSettingScreenState extends ConsumerState<DrivingEndOptionSettingScreen> {
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
              TitleText(title: '${model.autoStartType.value} 해제 후', fontWeight: FontWeight.w500,),
              TitleText(title: '운행 기록 종료 대기시간 설정', fontWeight: FontWeight.w500,),
              SizedBox(height: 16.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_rounded, size: 20, color: BODY_TEXT_COLOR_03,),
                  SizedBox(width: 6.0,),
                  Expanded(
                    child: BodyText(
                      title: '${model.autoStartType.value}이 해제되어도 설정한 시간동안 운행기록이 종료되지 않습니다. 설정 시간 동안 차량이동이 없다면 자동으로 운행기록이 종료됩니다.',
                      textSize: BodyTextSize.REGULAR,
                      color: BODY_TEXT_COLOR_03
                    ),
                  )
                ],
              ),
              SizedBox(height: 16,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingEndCondition: DrivingEndCondition.SEC_30);
                    },
                    child: _autoDrivingDetailSettingText(text: '${DrivingEndCondition.SEC_30.textValue} 동안', isChecked: model.drivingEndCondition.value == '30')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingEndCondition: DrivingEndCondition.MIN_1);
                    },
                    child: _autoDrivingDetailSettingText(text: '${DrivingEndCondition.MIN_1.textValue} 동안', isChecked: model.drivingEndCondition.value == '60')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingEndCondition: DrivingEndCondition.MIN_3);
                    },
                    child: _autoDrivingDetailSettingText(text: '${DrivingEndCondition.MIN_3.textValue} 동안', isChecked: model.drivingEndCondition.value == '180')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingEndCondition: DrivingEndCondition.MIN_5);
                    },
                    child: _autoDrivingDetailSettingText(text: '${DrivingEndCondition.MIN_5.textValue} 동안', isChecked: model.drivingEndCondition.value == '300')
                ),
              ),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 6,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      ref.read(adDrivingOptionProvider.notifier).copyWith(drivingEndCondition: DrivingEndCondition.MIN_10);
                    },
                    child: _autoDrivingDetailSettingText(text: '${DrivingEndCondition.MIN_10.textValue} 동안', isChecked: model.drivingEndCondition.value == '600')
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
