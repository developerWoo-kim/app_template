import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/const/radius_type.dart';
import 'package:flutter/material.dart';

class BasicModalBottomSheet extends StatelessWidget {
  /// 모달바 내용
  final Widget content;
  /// 상단 모달바 표출 여부
  /// 기본 값 : false 미표출
  final bool showModalBar;
  /// 상단 둥글기
  /// 기본 값 : RadiusType.NONE 없음
  final RadiusType radiusType;

  const BasicModalBottomSheet({
    required this.content,
    this.showModalBar = false,
    this.radiusType = RadiusType.NONE,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            decoration: BoxDecoration(
              color: PRIMARY_COLOR_04,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radiusType.value),
                topRight: Radius.circular(radiusType.value),
              ),
            ),
            child: Column(
              children: [
                if(showModalBar)
                _buildModalBar(),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 35),
                  child: content
                )
              ],
            )
        ),
      ],
    );
  }

  Widget _buildModalBar() {
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: LINE_COLOR_01,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}
