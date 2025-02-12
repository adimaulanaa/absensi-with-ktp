

import 'package:shared_preferences/shared_preferences.dart';

class Helpers {

  static Future<void> helfersTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool isSetTimeIn = prefs.getBool('isSetTimeIn') ?? false;
    bool isSetTimeOut = prefs.getBool('isSetTimeOut') ?? false;
    if (!isSetTimeIn) {
      String formattedInTime = "08:30";
      await prefs.setString('setTimeIn', formattedInTime);
      await prefs.setBool('isSetTimeIn', false);
    }

    if (!isSetTimeOut) {
      String formattedOutTime = "17:30";
      await prefs.setString('setTimeOut', formattedOutTime);
      await prefs.setBool('isSetTimeOut', false);
    }
  }
}
