import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../providers/file_actions.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({Key? key, required this.videoPath, required this.type})
      : super(key: key);

  final String videoPath;
  final bool type;

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late ChewieController _chewieController;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _controller = VideoPlayerController.file(File(widget.videoPath));
    _initializeVideoPlayerFuture = _controller.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        fullScreenByDefault: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp]);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _controller.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<FileActions>(context, listen: false);
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          // _controller.play();

          if (snapShot.hasError) {
            print("Error while processing video ${snapShot.error}");
          }

          return Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.4,
                          width: MediaQuery.of(context).size.width,
                          child: Chewie(controller: _chewieController))),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
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
                    ),
                  ),
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
                                        await Share.shareFiles(
                                            [widget.videoPath]);
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
                                        FileActions _obj = FileActions();
                                        _provider.deleteFile(widget.videoPath);
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
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
