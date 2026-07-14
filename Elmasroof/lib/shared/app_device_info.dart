import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDeviceInfo {

  static late AppDeviceInfo _instance;
  static String get id => _instance._id;
  static String get versionName => _instance._versionName;

  String _id = '';
  String _versionName = '';

  static Future<void> init() async{
    _instance = AppDeviceInfo._();
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      _instance._id = (await deviceInfo.iosInfo).identifierForVendor ?? ''; // unique ID on iOS
    } else if(Platform.isAndroid) {
      _instance._id = await AndroidId().getId() ?? ''; // unique ID on Android
    }
    _instance._versionName = (await PackageInfo.fromPlatform()).version;
  }

  AppDeviceInfo._();
}