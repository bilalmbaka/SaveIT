import 'dart:io';
import 'dart:ui';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_saver/helpers/ad_helper.dart';
import 'package:social_saver/models/instapost.dart';
import 'package:dio/dio.dart';
import 'package:social_saver/models/posttype.dart';

import '../helpers/getpost.dart';

/*page to download instagram videos and images */
class InstagramPage extends StatefulWidget {
  const InstagramPage({Key? key}) : super(key: key);

  @override
  _InstagramPageState createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage> {
  TextEditingController _inputController = TextEditingController();
  double progress = 0.0;
  List<InstaPost> _posts = [];

  // AdHelper _adHelper = AdHelper();
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validate() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        loading = false;
      });
      return;
    }
  }

  void _download(String url, String fileName) async {
    Dio dio = Dio();
    /* download the file */

    if (!Directory("/storage/emulated/0/Saveit/instagram").existsSync()) {
      //create the directory if it dosen't exist yet
      Directory("/storage/emulated/0/Saveit/instagram")
          .createSync(recursive: true);
    }

    try {
      Response response = await dio.get(url,
          onReceiveProgress: updateDownloadProgress,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }));
      print(response.headers);
      File file = File("/storage/emulated/0/Saveit/instagram/$fileName");
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void updateDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        progress = received / total * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Enter the link below: "),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _inputController,
                      validator: (str) {
                        if (str!.isEmpty || str == " " || str == "") {
                          return "Field cannot be empty";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ))),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    validate();

                    RewardedAd rewardedAd;

                    RewardedAd.load(
                        adUnitId: "ca-app-pub-4285444827369918/8380407490",
                        // "ca-app-pub-3940256099942544/5224354917" //test Ad,

                        request: AdRequest(),
                        rewardedAdLoadCallback:
                            RewardedAdLoadCallback(onAdLoaded: (ad) async {
                          print("Succeffully got the add");
                          rewardedAd = ad;
                          _posts = await getPost(
                              url: "${_inputController.text}/?__a=1");
                          rewardedAd.fullScreenContentCallback =
                              FullScreenContentCallback(
                            onAdShowedFullScreenContent: (RewardedAd ad) {
                              print('%ad onAdShowedFullScreenContent.');
                            },
                            onAdDismissedFullScreenContent: (RewardedAd ad) {
                              print('$ad onAdDismissedFullScreenContent.');

                              setState(() {});
                              ad.dispose();
                              rewardedAd.dispose();
                              loading = false;
                            },
                            onAdFailedToShowFullScreenContent:
                                (RewardedAd ad, AdError error) {
                              print(
                                  '$ad onAdFailedToShowFullScreenContent: $error');
                              ad.dispose();
                              rewardedAd.dispose();
                              setState(() {
                                loading = false;
                              });
                            },
                            onAdImpression: (RewardedAd ad) =>
                                print('$ad impression occurred.'),
                          );
                          rewardedAd.show(onUserEarnedReward:
                              (AdWithoutView ad, RewardItem rewardItem) {
                            //show the rewarded Ad
                          });
                        }, onAdFailedToLoad: (LoadAdError error) async {
                          print("Error loading intersitialAd $error");
                          _posts = await getPost(
                              url:
                                  "${_inputController.text}/?__a=1"); //get the instagram post
                          setState(() {
                            loading = false;
                          });
                        }));

                    // var interstitialAd;
                    //
                    // await InterstitialAd.load(
                    //   adUnitId: "ca-app-pub-3940256099942544/1033173712",
                    //   request: AdRequest(),
                    //   adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) async {
                    //     print ("Succeffully got the add");
                    //     interstitialAd = ad;
                    //     _posts = await getPost(url: "${_inputController.text}/?__a=1"); //get the information
                    //handle full screen content
                    //     interstitialAd.fullScreenContentCallback =
                    //         FullScreenContentCallback(
                    //           onAdShowedFullScreenContent: (InterstitialAd ad) {
                    //             print('%ad onAdShowedFullScreenContent.');
                    //           },
                    //           onAdDismissedFullScreenContent: (
                    //               InterstitialAd ad) {
                    //             print('$ad onAdDismissedFullScreenContent.');
                    //
                    //             setState(() {});
                    //             ad.dispose();
                    //             loading = false;
                    //           },
                    //           onAdFailedToShowFullScreenContent: (
                    //               InterstitialAd ad, AdError error) {
                    //             print(
                    //                 '$ad onAdFailedToShowFullScreenContent: $error');
                    //             ad.dispose();
                    //             setState(() {
                    //               loading = false;
                    //             });
                    //           },
                    //           onAdImpression: (InterstitialAd ad) =>
                    //               print('$ad impression occurred.'),
                    //         );
                    //     interstitialAd.show();
                    //   },
                    //     onAdFailedToLoad: (LoadAdError error) async { print ("Error loading intersitialAd $error");
                    //     _posts = await getPost(url: "${_inputController.text}/?__a=1"); //get the instagram post
                    //     setState(() {
                    //         loading = false;
                    //       });
                    //   },
                    // ),
                    // );
                  },
                  child: const Text("Fetch"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff085e55)),
                      fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 1.3, 50))),
                ),
                if (loading) LinearProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                if (_posts.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _posts.length,
                        itemBuilder: (ctx, index) => (_posts[index].postType ==
                                PostType.GraphImage)
                            ? Stack(
                                children: [
                                  SizedBox(
                                      width: 150,
                                      height: 250,
                                      child: Image.network(
                                          _posts[index].thumbnailUrl!)),
                                  if (progress == 0)
                                    Positioned(
                                        right: 40,
                                        top: 100,
                                        child: GestureDetector(
                                          onTap: () {
                                            progress = 0;
                                            //Download the content to local storage
                                            _posts.forEach((element) {
                                              _download(element.displayURL!,
                                                  "${DateTime.now().toString()}.jpg");
                                            });
                                          },
                                          child: ClipRRect(
                                              child: Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 3)),
                                                  child: const Icon(
                                                    Icons.download_outlined,
                                                    color: Colors.white,
                                                  ))),
                                        )),
                                  if (progress > 0)
                                    Positioned(
                                        right: 40,
                                        top: 100,
                                        child: ClipRRect(
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 3)),
                                                child: Center(
                                                    child: Text(
                                                  "${progress.toStringAsFixed(1)} %",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ))))),
                                ],
                              )
                            : Stack(
                                children: [
                                  SizedBox(
                                      width: 150,
                                      height: 250,
                                      child: Image.network(
                                          _posts[index].thumbnailUrl!)),
                                  if (progress == 0)
                                    Positioned(
                                        right: 40,
                                        top: 100,
                                        child: GestureDetector(
                                          onTap: () {
                                            progress = 0;
                                            //Download the content to local storage
                                            _posts.forEach((element) {
                                              _download(element.displayURL!,
                                                  "${DateTime.now().toString()}.mp4");
                                            });
                                          },
                                          child: ClipRRect(
                                              child: Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 3)),
                                                  child: const Icon(
                                                    Icons.download_outlined,
                                                    color: Colors.white,
                                                  ))),
                                        )),
                                  if (progress > 0)
                                    Positioned(
                                        right: 40,
                                        top: 100,
                                        child: ClipRRect(
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 3)),
                                                child: Center(
                                                    child: Text(
                                                  "${progress.toStringAsFixed(1)} %",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ))))),
                                ],
                              )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
