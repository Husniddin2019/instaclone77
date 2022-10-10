
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/servise/prefs_servise.dart';


class FileService {
  static final _storage = FirebaseStorage.instance;
  static final folder_post = "post_images";
  static final folder_user = "user_images";



  static Future<String?> uploadUserImage(File _image) async {
    String? uid = await Prefs.loadUserId();
    String? img_name = uid;
    Reference firebaseStorageRef = _storage.ref().child(folder_user).child(img_name!);
    var uploadTask = firebaseStorageRef.putFile(_image);
    var taskSnapshot = await uploadTask.whenComplete(() => null);

    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }
    return null;

  }
  static Future<String?> uploadPostImage(File _image) async {
    String? uid = await Prefs.loadUserId();
    String img_name = uid! +"_" + DateTime.now().toString();
    Reference firebaseStorageRef = _storage.ref().child(folder_post).child(img_name);
    var uploadTask = firebaseStorageRef.putFile(_image);
    var taskSnapshot = await uploadTask.whenComplete(() => null);
    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }
    return null;
  }

}
