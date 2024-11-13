import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> location() async {
    final access = await Permission.location.status;
    debugPrint('Access ::: ${access.name}');
    switch (access) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        var result = await Permission.locationWhenInUse.request();
        debugPrint('Result ::: ${result.name}');
        if(result.isDenied || result.isPermanentlyDenied) {
          return false;
        }
        return true;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        return false;
      case PermissionStatus.granted:
        return true;
      default:
        return false;
    }
  }

  static Future<bool> locationAlways() async {
    final access = await Permission.locationAlways.status;
    debugPrint('Access ::: ${access.name}');
    switch (access) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        var alwaysResult = await Permission.locationAlways.request();
        debugPrint('alwaysResult ::: ${alwaysResult.name}');
        if(alwaysResult.isDenied || alwaysResult.isPermanentlyDenied) {
          return false;
        }
        return true;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        return false;
      case PermissionStatus.granted:
        return true;
      default:
        return false;
    }
  }

  static Future<bool> notification() async {
    final notificationAccess = await Permission.notification.status;
    switch(notificationAccess) {
      case PermissionStatus.denied :
      case PermissionStatus.restricted :
        final result = await Permission.notification.request();
        if(result.isDenied || result.isPermanentlyDenied) {
          return false;
        }
        return true;
      case PermissionStatus.permanentlyDenied :
        openAppSettings();
        return false;
      case PermissionStatus.granted :
        return true;
      default :
        return false;
    }
  }

  static Future<bool> bluetoothScan() async {
    final bluetoothAccess = await Permission.bluetoothScan.status;
    switch(bluetoothAccess) {
      case PermissionStatus.denied :
      case PermissionStatus.restricted :
        final result = await Permission.bluetoothScan.request();
        if(result.isDenied || result.isPermanentlyDenied) {
          return false;
        }
        return true;
      case PermissionStatus.permanentlyDenied :
        openAppSettings();
        return false;
      case PermissionStatus.granted :
        return true;
      default :
        return false;
    }
  }

  static Future<bool> bluetoothConnect() async {
    final bluetoothAccess = await Permission.bluetoothConnect.status;
    switch(bluetoothAccess) {
      case PermissionStatus.denied :
      case PermissionStatus.restricted :
        final result = await Permission.bluetoothConnect.request();
        if(result.isDenied || result.isPermanentlyDenied) {
          return false;
        }
        return true;
      case PermissionStatus.permanentlyDenied :
        openAppSettings();
        return false;
      case PermissionStatus.granted :
        return true;
      default :
        return false;
    }
  }
}