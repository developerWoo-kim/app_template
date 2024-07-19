import 'package:app_template/common/const/custom_method_channel.dart';
import 'package:app_template/template/sample/adruck/driving_option_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveAdDrivingOptionProvider = AutoDisposeStateNotifierProvider<SaveAdDrivingOptionStateNotifier, DrivingOptionModelBase>((ref) {
  return SaveAdDrivingOptionStateNotifier();
});

class SaveAdDrivingOptionStateNotifier extends StateNotifier<DrivingOptionModelBase> {
  SaveAdDrivingOptionStateNotifier() : super(DrivingOptionModelLoading()) {
    getAdDrivingOption();
  }

  Future<void> getAdDrivingOption() async {
    state = DrivingOptionModelLoading();
    try {
      final Map<dynamic, dynamic> result = await CustomMethodChannel.auto_driving_option_channel.invokeMethod('getOption');

      state = DrivingOptionModel(
          autoStartType: AutoStartType.fromCode(result['autoStartType'] as String),
          beaconAddress: result['beaconAddress'] as String,
          drivingStartCondition: DrivingStartCondition.fromCode(result['drivingStartCondition'] as String),
          drivingEndCondition: DrivingEndCondition.fromCode(result['drivingEndCondition'] as String)
      );
      print(state);
    } on PlatformException catch (e) {
      state = DrivingOptionModel(
          autoStartType: AutoStartType.NONE,
          beaconAddress: '',
          drivingStartCondition: DrivingStartCondition.IMMEDIATE,
          drivingEndCondition: DrivingEndCondition.MIN_5
      );
    }
  }

  void saveAdDrivingOption(DrivingOptionModel model) {
    state = DrivingOptionModel(
        autoStartType: model.autoStartType,
        beaconAddress: model.beaconAddress,
        drivingStartCondition: model.drivingStartCondition,
        drivingEndCondition: model.drivingEndCondition
    );
  }
}

final adDrivingOptionProvider = AutoDisposeStateNotifierProvider<AdDrivingOptionStateNotifier, DrivingOptionModel>((ref) {
  final state = ref.read(saveAdDrivingOptionProvider);
  final model = state as DrivingOptionModel;
  return AdDrivingOptionStateNotifier(model);
});

class AdDrivingOptionStateNotifier extends StateNotifier<DrivingOptionModel>{
  AdDrivingOptionStateNotifier(super._state);

  copyWith({
    AutoStartType? autoStartType,
    String? beaconAddress,
    DrivingStartCondition? drivingStartCondition,
    DrivingEndCondition? drivingEndCondition,
  }) {
    DrivingOptionModel model = state as DrivingOptionModel;
    state = model.copyWith(
      autoStartType: autoStartType,
      beaconAddress: beaconAddress,
      drivingStartCondition: drivingStartCondition,
      drivingEndCondition: drivingEndCondition
    );
  }
}