import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as pathFile;

class FileActions with ChangeNotifier {
  String? _platform = " ";

  Future<void> getSharedPreferences() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _platform = await _sharedPreferences.getString("activePlatform");
  }

  String? getSelectedPlatform() {
    return _platform;
  }

  void setSelectedPlatform(String platformName) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.setString("activePlatform", platformName);
    notifyListeners();
  }

  static void saveFile({required String platform, required String path}) async {
    /* move files to permanent storage */

    //TODO check for storage space left.

    var _baseName = pathFile.basename(path);
    if (!Directory("/storage/emulated/0/Saveit/$platform").existsSync()) {
      //create the directory if it dosen't exist yet
      Directory("/storage/emulated/0/Saveit/$platform")
          .createSync(recursive: true);
    }
    File _file = File(path);
    await _file.copy("/storage/emulated/0/Saveit/$platform/$_baseName");
  }

  static Future<bool> checkFileDownloaded(
      {required String platform, required String path}) async {
    // check if a file has already been downloaded
    String _result = "";

    switch (platform) {
      case "Whatsapp":
        _result = "/storage/emulated/0/Saveit/whatsapp/";
        break;
      case "businesswhatsapp":
        _result = "/storage/emulated/0/Saveit/businesswhatsapp/";
        break;
      case "gbwhatsapp":
        _result = "/storage/emulated/0/Saveit/gbwhatsapp/";
        break;
      case "instagram":
        _result = "/storage/emulated/0/Saveit/whatsapp/";
        break;
      default:
        _result = "/storage/emulated/0/Saveit/gbwhatsapp/";
    }

    // print ("The path is ${_result+pathFile.basename(path)}");

    if (File(_result + pathFile.basename(path)).existsSync()) {
      return true;
    } else {
      // print ("File does not exists");
      return false;
    }
  }

  void deleteFile(String path) {
    /* delete a file */

    File _filePath = File(path);
    _filePath.deleteSync();
    notifyListeners();
  }
}
