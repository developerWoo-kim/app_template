import 'package:app_template/third_party/naver/map/model/camera_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraChangeProvider = AutoDisposeStateNotifierProvider<CameraChangeNotifier, CameraStateBase>
  ((ref) => CameraChangeNotifier());

class CameraChangeNotifier extends StateNotifier<CameraStateBase> {
  CameraChangeNotifier() : super(CameraStateStanBy());

  void action() {
    state = CameraStateAction(state: false);
  }

  void move() {
    if(state is CameraStateAction) {
      final pState = state as CameraStateAction;
      if(!pState.state) {
        state = CameraStateAction(state: true);
      };
    }
  }

  void stop() {
    if(state is CameraStateAction) {
      final pState = state as CameraStateAction;
      state = CameraStateAction(state: false);
    }
  }
}