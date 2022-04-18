import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../download__manual_icons.dart';
import '../pages/single_item.dart';
import '../providers/file_actions.dart';

/* class to display each image */

class ImageCard extends StatefulWidget {
  /* class for each image or video card */
  const ImageCard({
    Key? key,
    required this.path,
    required this.platform,
    required this.isLocalType,
    required this.index,
  }) : super(key: key);

  final String path;
  final String platform;
  final bool isLocalType;
  final int index;

  // final bool downloaded;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<FileActions>(context, listen: false);

    return Container(
      // color: Colors.red,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SingleItem(path: widget.path, type: widget.isLocalType)));
        },
        child: Stack(
          children: [
            Card(
              elevation: 30,
              child: Image.file(File(widget.path)),
            ),
            FutureBuilder(
                future: FileActions.checkFileDownloaded(
                    platform: widget.platform, path: widget.path),
                builder: (ctx, snapShot) {
                  if (snapShot.hasData) {
                    var data = snapShot.data as bool;

                    Widget _icon = const Icon(
                      Download_Manual.download,
                      color: Colors.white,
                      size: 20,
                    );

                    if (!widget.isLocalType && !data) {
                      _icon = GestureDetector(
                        onTap: () async {
                          if (data) {
                            // print("in here buddy");
                            setState(() {});
                            null;
                          } else {
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
                                      print('%ad onAdShowedFullScreenContent.');
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
                                  print("Error loading intersitialAd $error");

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
                                  platform: widget.platform, path: widget.path);
                              setState(() {
                                _downloading = false;
                              });
                            }
                          }
                        },
                        child: (_downloading)
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Download_Manual.download,
                                color: Colors.white,
                                size: 20,
                              ),
                      );
                    } else if (!widget.isLocalType && data) {
                      _icon = const Icon(
                        Icons.download_done,
                        color: Colors.white,
                        size: 20,
                      );
                    } else {
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
                        padding: const EdgeInsets.only(bottom: 15.0, right: 10),
                        child: (_downloading)
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                                radius: 17,
                                backgroundColor: const Color(0xF26D6767),
                                child: _icon),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
