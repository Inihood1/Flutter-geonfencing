import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';


class Utils{
  static int appVersion = 1;

  static void showToast(String sms){
    Fluttertoast.showToast(
        msg: sms,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static Future<File> compressImages(File file) async {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    String id2 = Uuid().v4();
    String id = id2 + time;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/$id.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 100));
    return  compressedImageFile;
  }

}