import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/user/user_model.dart';

class PrefsService {
  Future<void> saveUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = user.toJson();
    await prefs.setString('userData', json.encode(userMap));
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }
}