import 'package:flutter/services.dart';

class CustomMethodChannel {
  static final auto_driving_option_channel = MethodChannel('auto_driving_option_channel');

  static final timer_channel = MethodChannel('timer_channel');

  static final timer_event_channel = EventChannel('timer_event_channel');
}