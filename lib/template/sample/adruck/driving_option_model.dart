import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

abstract class DrivingOptionModelBase {}

class DrivingOptionModelLoading extends DrivingOptionModelBase{}

class DrivingOptionModel extends DrivingOptionModelBase{
  final AutoStartType autoStartType;
  final String beaconAddress;
  final DrivingStartCondition drivingStartCondition;
  final DrivingEndCondition drivingEndCondition;

  DrivingOptionModel({
    required this.autoStartType,
    required this.beaconAddress,
    required this.drivingStartCondition,
    required this.drivingEndCondition
  });

  DrivingOptionModel copyWith({
    AutoStartType? autoStartType,
    String? beaconAddress,
    DrivingStartCondition? drivingStartCondition,
    DrivingEndCondition? drivingEndCondition,
  }) {
    return DrivingOptionModel(
        autoStartType: autoStartType ?? this.autoStartType,
        beaconAddress: beaconAddress ?? this.beaconAddress,
        drivingStartCondition: drivingStartCondition ?? this.drivingStartCondition,
        drivingEndCondition: drivingEndCondition ?? this.drivingEndCondition
    );
  }
}

enum AutoStartType {
  NONE('사용 안함', Icon(Icons.do_not_disturb_alt, color: Colors.red, size: 25,), 'none'),
  BATTERY('배터리 충전', Icon(Icons.battery_charging_full, color: BATTERY_COLOR, size: 25,), 'battery'),
  BEACON('비콘 연결', Icon(Icons.bluetooth, color: BLUETOOTH_COLOR, size: 25,), 'beacon');

  const AutoStartType(this.value, this.icon, this.code);

  final String value;
  final Icon icon;
  final String code;

  static AutoStartType fromCode(String code) {
    return AutoStartType.values.firstWhere((element) => element.code == code, orElse: () => AutoStartType.NONE);
  }
}

enum DrivingStartCondition {
  IMMEDIATE('즉시운행', ''),
  DETECT_10('10km/h', '10'),
  DETECT_15('15km/h', '15'),
  DETECT_20('20km/h', '20');
  const DrivingStartCondition(this.textValue, this.value);

  final String textValue;
  final String value;

  static DrivingStartCondition fromCode(String code) {
    return DrivingStartCondition.values.firstWhere((element) => element.value == code, orElse: () => DrivingStartCondition.IMMEDIATE);
  }
}

enum DrivingEndCondition {
  SEC_30('30초', '30'),
  MIN_1('1분', '60'),
  MIN_3('3분', '180'),
  MIN_5('5분', '300'),
  MIN_10('10분', '600');

  const DrivingEndCondition(this.textValue, this.value);

  final String textValue;
  final String value;

  static DrivingEndCondition fromCode(String code) {
    return DrivingEndCondition.values.firstWhere((element) => element.value == code, orElse: () => DrivingEndCondition.MIN_5);
  }
}