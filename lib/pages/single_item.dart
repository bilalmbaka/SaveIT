import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/file_actions.dart';

class SingleItem extends StatefulWidget {
  const SingleItem({Key? key, required this.path, required this.type})
      : super(key: key);

  final String path;
  final bool type;

  @override
  _SingleItemState createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  /* TODO
      1. implement the sharing to different platforms
      2. Implement the sharing to whatsapp
  */

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<FileActions>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )),
            Align(
                alignment: Alignment.center,
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(File(widget.path)))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: (widget.type)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF20c65a),
                              radius: 25,
                              child: GestureDetector(
                                onTap: () async {
                                  await Share.shareFiles([widget.path]);
                                },
                                child: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // CircleAvatar(
                            //   backgroundColor: const Color(0xFF20c65a),
                            //   radius: 25,
                            //   child: GestureDetector(
                            //     child: const FaIcon(
                            //       FontAwesomeIcons.whatsapp,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0xFF20c65a),
                              radius: 25,
                              child: GestureDetector(
                                onTap: () {
                                  // FileActions _obj = FileActions();
                                  _provider.deleteFile(widget.path);
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // CircleAvatar(
                            //   backgroundColor: const Color(0xFF20c65a),
                            //   radius: 25,
                            //
                            //   child: GestureDetector(
                            //     onTap: () {
                            //
                            //     },
                            //     child: const Icon(Download_Manual.download,color: Colors.white,),
                            //   ),
                            // )
                          ],
                        )),
            )
          ]),
        ),
      ),
    );
  }
}
