import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  static late SharedPreferences _sharedPref;

  static init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> putData({
    required String key,
    required dynamic value,
  }) {
    if(value is bool) {
      return _sharedPref.setBool(key, value);
    }
    if(value is int) {
      return _sharedPref.setInt(key, value);
    }
    if(value is double) {
      return _sharedPref.setDouble(key, value);
    }
    if(value is String) {
      return _sharedPref.setString(key, value);
    }
    return _sharedPref.setStringList(key, value);
  }

  static dynamic getData({required String key}) => _sharedPref.get(key);

}