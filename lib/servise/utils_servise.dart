
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instaclone/servise/prefs_servise.dart';

class Utils {
  static Future<Map<String?, String?>>  deviceParams() async{
    Map<String?, String?>? params = new Map();
    var deviceInfo = DeviceInfoPlugin();
    String? fcm_token = await Prefs.loadFCM();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id': iosDeviceInfo.identifierForVendor,
        'device_type': "I",
        'device_token': fcm_token,
      });
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      params.addAll({
        'device_id': androidDeviceInfo.id,
        'device_type': "A",
        'device_token': fcm_token,
      });
    }
    return params;
  }

  static void fireToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static String currentDate() {
    DateTime now = DateTime.now();

    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}:${now.minute.toString()}";
    return convertedDateTime;
  }


  static Future<bool> dialogCommon(BuildContext context, String title, String message, bool isSingle) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              !isSingle
                  ? FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
                  : SizedBox.shrink(),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }
  static Future<void> showLocalNotification(Map<String, dynamic> message) async {
    String title = message['title'];
    String body = message['body'];

    if(Platform.isAndroid){
      title = message['notification']['title'];
      body = message['notification']['body'];
    }

    var android = AndroidNotificationDetails('channelId', 'channelName');
   // var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android,);

    int id = Random().nextInt(1000000000)+1;
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);
  }


}

