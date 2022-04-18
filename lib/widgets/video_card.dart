import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_saver/widgets/play_video.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../download__manual_icons.dart';
import '../providers/file_actions.dart';

class VideoCard extends StatefulWidget {
  /* class for each image or video card */
  const VideoCard({
    Key? key,
    required this.path,
    required this.platform,
    required this.isLocalType,
    required this.index,
  }) : super(key: key);

  // final bool exists;
  final String path;
  final String platform;
  final bool isLocalType;
  final int index;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<FileActions>(context, listen: false);
    return FutureBuilder(
        future: VideoThumbnail.thumbnailData(
            video: widget.path, imageFormat: ImageFormat.JPEG, quality: 100),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            var _path = snapShot.data as dynamic;

            return Stack(
              children: [
                Card(
                  elevation: 30,
                  child: Image.memory(
                    _path,
                    // fit: BoxFit.fill,
                  ),
                ),
                FutureBuilder(
                    future: FileActions.checkFileDownloaded(
                        platform: widget.platform, path: widget.path),
                    builder: (ctx, snapShot) {
                      if (snapShot.hasData) {
                        var data = snapShot.data as bool;

                        Widget _icon = const Icon(
                          //the default icon to show
                          Download_Manual.download,
                          color: Colors.white,
                          size: 20,
                        );

                        if (!widget.isLocalType && !data) {
                          //if it is not of type local and it has not been downloaded
                          _icon = GestureDetector(
                            onTap: () async {
                              if (data) {
                                // print("in here buddy");
                                setState(() {});
                                null;
                              } else {
                                //   setState(() {
                                //     // print("in set dstate");
                                //     _downloading = true;
                                //   });
                                //   FileActions.saveFile(
                                //       platform: widget.platform,
                                //       path: widget.path);
                                //   setState(() {
                                //     _downloading = false;
                                //   });
                                // }

                                if (widget.index % 4 == 0) {
                                  var interstitialAd;

                                  setState(() {
                                    // print("in set dstate");
                                    _downloading = true;
                                  });

                                  await InterstitialAd.load(
                                    adUnitId:
                                        "ca-app-pub-3940256099942544/8691691433",
                                    //"ca-app-pub-3940256099942544/1033173712",
                                    request: AdRequest(),
                                    adLoadCallback: InterstitialAdLoadCallback(
                                        onAdLoaded: (InterstitialAd ad) async {
                                      interstitialAd = ad;
                                      //handle full screen content
                                      interstitialAd.fullScreenContentCallback =
                                          FullScreenContentCallback(
                                        onAdShowedFullScreenContent:
                                            (InterstitialAd ad) {
                                          print(
                                              '%ad onAdShowedFullScreenContent.');
                                        },
                                        onAdDismissedFullScreenContent:
                                            (InterstitialAd ad) {
                                          print(
                                              '$ad onAdDismissedFullScreenContent.');

                                          FileActions.saveFile(
                                              platform: widget.platform,
                                              path: widget.path);
                                          setState(() {
                                            _downloading = false;
                                          });
                                          ad.dispose();
                                        },
                                        onAdFailedToShowFullScreenContent:
                                            (InterstitialAd ad, AdError error) {
                                          print(
                                              '$ad onAdFailedToShowFullScreenContent: $error');

                                          FileActions.saveFile(
                                              platform: widget.platform,
                                              path: widget.path);
                                          setState(() {
                                            _downloading = false;
                                          });
                                          ad.dispose();
                                        },
                                        onAdImpression: (InterstitialAd ad) =>
                                            print('$ad impression occurred.'),
                                      );
                                      interstitialAd.show();
                                    }, onAdFailedToLoad: (LoadAdError error) {
                                      print(
                                          "Error loading intersitialAd $error");

                                      FileActions.saveFile(
                                          platform: widget.platform,
                                          path: widget.path);
                                      setState(() {
                                        _downloading = false;
                                      });
                                    }),
                                  );
                                } else {
                                  FileActions.saveFile(
                                      platform: widget.platform,
                                      path: widget.path);
                                  setState(() {
                                    _downloading = false;
                                  });
                                }
                              }
                            },
                            child: (_downloading)
                                ? CircularProgressIndicator()
                                : Icon(
                                    Download_Manual.download,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          );
                        } else if (!widget.isLocalType && data) {
                          // if it is not of type local and is has been downloaded
                          _icon = const Icon(
                            Icons.download_done,
                            color: Colors.white,
                            size: 20,
                          );
                        } else {
                          // if it is not in local and it has not been downloaded
                          _icon = GestureDetector(
                            onTap: () {
                              _provider.deleteFile(widget.path);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          );
                        }

                        return Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 25.0, right: 10),
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: const Color(0xF26D6767),
                              child: (_downloading)
                                  ? const CircularProgressIndicator()
                                  : CircleAvatar(
                                      radius: 17,
                                      backgroundColor: const Color(0xF26D6767),
                                      child: _icon),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      // showDialog(
                      //     context: context,
                      //     builder: (ctx) {
                      //       return AlertDialog(
                      //           backgroundColor: Colors.transparent,
                      //           insetPadding: const EdgeInsets.all(0),
                      //
                      //           content: );
                      //     });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayVideo(
                                    videoPath: widget.path,
                                    type: widget.isLocalType,
                                  )));
                    },
                    child: ClipRRect(
                        child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 3)),
                      child: const Icon(
                        Icons.play_arrow_outlined,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ))
              ],
            );
          } else if (snapShot.hasError) {
            // print("There is error ${snapShot.error}");
            return const Align(
                alignment: Alignment.center, child: Text("Unknown Error"));
          } else {
            return const Align(
              alignment: Alignment.center,
              // child: CircularProgressIndicator()
            );
            // );
          }
        });
  }
}
