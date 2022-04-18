import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as pathFile;
import 'package:social_saver/pages/instagram_page.dart';

import '../providers/file_actions.dart';
import '../providers/file_actions.dart';
import '../widgets/video_card.dart';
import '../widgets/image_card.dart';

class DisplayContent extends StatefulWidget {
  const DisplayContent({Key? key, required this.type, required this.isLocal})
      : super(key: key);

  final String type;
  final bool isLocal;

  @override
  _DisplayContentState createState() => _DisplayContentState();
}

class _DisplayContentState extends State<DisplayContent> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<FileActions>(builder: (ctx, provider, _) {
      Future<String?> getPath() async {
        await provider.getSharedPreferences();
        var _check = provider.getSelectedPlatform();

        return _check;
      }

      return FutureBuilder(
          future: getPath(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              if (snapShot.hasData) {
                var _data = snapShot.data as String;
                String _result = "";

                if (!widget.isLocal) {
                  //if we are getting statuses
                  switch (_data) {
                    case "Whatsapp":
                      _result = "/storage/emulated/0/WhatsApp/Media/.Statuses";
                      break;
                    case "businesswhatsapp":
                      _result =
                          "/storage/emulated/0/WhatsApp Business/Media/.Statuses";
                      break;
                    case "gbwhatsapp":
                      _result =
                          "/storage/emulated/0/GBWhatsApp/Media/.Statuses"; //emulated/0/GBWhatsApp/Media/.Statuses
                      break;
                      // case "instagram":
                      //   _result =
                      //       "/storage/emulated/0/android/data/com.instagram.android/files";
                      break;
                    default:
                      _result = "/storage/emulated/0/WhatsApp/Media/.Statuses";
                  }
                } else {
                  // if we are getting local saved files
                  switch (_data) {
                    case "Whatsapp":
                      _result = "/storage/emulated/0/Saveit/Whatsapp/";
                      break;
                    case "businesswhatsapp":
                      _result = "/storage/emulated/0/Saveit/businesswhatsapp/";
                      break;
                    case "gbwhatsapp":
                      _result = "/storage/emulated/0/Saveit/gbwhatsapp/";
                      break;
                    case "instagram":
                      _result = "/storage/emulated/0/Saveit/instagram/";
                      break;
                    default:
                      _result = "/storage/emulated/0/Saveit/Whatsapp/";
                  }
                }

                if (_data == "instagram" && !widget.isLocal) {
                  return InstagramPage();
                }

                if (!Directory("$_result").existsSync()) {
                  /* fetch everyting in the whats app business directory */
                  return (_data == "instagram")
                      ? const Center(
                          child: Text(
                          "Nothing Downloaded Yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins"),
                        ))
                      : Center(
                          child: Text(
                          "Please Install $_data",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins"),
                        ));
                } else {
                  // print ("The result is $_result");
                  // Directory("$_result").listSync().map((e) => print ("the path $e"));

                  var _filesList = Directory("$_result")
                      .listSync()
                      .map((item) => item.path)
                      .where((item) {
                    if (widget.type == "images") {
                      return item.endsWith(".jpg") || item.endsWith(".png");
                    } else {
                      return item.endsWith(".mp4") || item.endsWith(".3gp");
                    }
                  }).toList(growable: false);

                  if (_filesList.isNotEmpty) {
                    /* if the list is not empty display the images */

                    return SingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: _filesList.map((e) {
                          //return each item found in the path
                          if (widget.type == "images") {
                            index++;
                            return ImageCard(
                              isLocalType: widget.isLocal,
                              path: e,
                              platform: _data,
                              index: index,
                              // downloaded: false,
                            );
                          } else {
                            index++;
                            return VideoCard(
                              isLocalType: widget.isLocal,
                              path: e,
                              platform: _data,
                              index: index,
                            );
                          }
                        }).toList(),
                      ),

                      // child: GridView.builder(
                      //     itemCount: _filesList.length,
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 2,
                      //     ), itemBuilder: (ctx, index) {
                      //   if (widget.type == "images") {
                      //     return ImageCard(
                      //       isLocalType: widget.isLocal,
                      //       path: _filesList[index],
                      //       platform: _data,
                      //       // downloaded: false,
                      //     );
                      //   } else {
                      //     // print ("The file is ${_filesList[index]}");
                      //     return VideoCard(
                      //       isLocalType: widget.isLocal,
                      //
                      //       path: _filesList[index],
                      //       platform: _data,
                      //     );
                      //   }
                      // });
                    );
                  } else {
                    return Container(
                      // height: constraints.maxHeight,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/send_background.jpg"))),
                    );
                  }
                }
              } else if (snapShot.hasError) {
                return Container(
                  child: const Text("Error!!"),
                );
              } else {
                return Container();
              }
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const CircularProgressIndicator()],
              );
            }
          });
    });
  }
}
