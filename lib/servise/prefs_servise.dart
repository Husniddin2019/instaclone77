import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  static Future<bool> saveUserId(String user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_id', user_id);
  }

  static Future<String?> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_id');
    return token;
  }

  static Future<bool> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('user_id');
  }

  static Future<bool> saveFCM(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("====> $fcmToken");
    return prefs.setString('fcm_token', fcmToken);

  }

  static Future<String?> loadFCM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     String? token = prefs.getString('fcm_token');
    print("====> $token");

    return token;
  }


}
