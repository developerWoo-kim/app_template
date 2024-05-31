abstract class CameraStateBase {}

class CameraStateStanBy extends CameraStateBase {}

class CameraStateAction extends CameraStateBase{
  final bool state;

  CameraStateAction({
    required this.state
  });

}