import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_saver/helpers/ad_helper.dart';
import 'package:social_saver/providers/file_actions.dart';

import '../pages/display_content.dart';
import '../pages/help.dart';
import '../providers/file_actions.dart';
import '../staggard_bar_manual_icons.dart';
import '../widgets/main_drawer.dart';

class RecentStatus extends StatefulWidget {
  const RecentStatus({Key? key, required this.isLocal, this.selectedPage = 0})
      : super(key: key);

  final bool isLocal;
  final int selectedPage;

  @override
  _RecentStatusState createState() => _RecentStatusState();
}

class _RecentStatusState extends State<RecentStatus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _pages = [];
  String? _result;
  int _currentPageIndex = 0;
  final AdHelper _adObj = AdHelper();
  late Timer bannerTimer;

  late BannerAd _bannerAd;
  bool _isBannerReady = false;

  void _loadBannerAd(String type) {
    this._bannerAd = BannerAd(
        adUnitId: "ca-app-pub-4285444827369918/4826506990",

        //test Ad "ca-app-pub-3940256099942544/6300978111",

        request: AdRequest(),
        size: (type == "instagram") ? AdSize.mediumRectangle : AdSize.banner,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerReady = true;
          });
        }, onAdFailedToLoad: (ad, err) {
          _isBannerReady = false;
          ad.dispose();
        }));
  }

  @override
  void initState() {
    _pages.addAll([
      DisplayContent(
        type: "images",
        isLocal: widget.isLocal,
      ),
      DisplayContent(
        type: "videos",
        isLocal: widget.isLocal,
      )
    ]);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bannerTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var _provider = Provider.of<FileActions>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(StaggardBar_manual.bars_staggered_solid,
              color: Color(0xff085e55)),
          onTap: () {
            /* handle drawer */
            if (_scaffoldKey.currentState!.hasDrawer) {
              if (_scaffoldKey.currentState!.isDrawerOpen) {
                // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                Navigator.of(context).pop();
              } else {
                // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                _scaffoldKey.currentState!.openDrawer();
              }
            }
          },
        ),

        actions: [
          // GestureDetector(
          //   onTap: () {},
          //   child: const Icon(
          //     Check_Manual.check,
          //     color: Color(0xff085e55),
          //     size: 20,
          //   ),
          // ),

          Align(
            //which icon should i display on the appBar
            alignment: Alignment.center,
            child: Consumer<FileActions>(builder: (context, provider, _) {
              provider.getSharedPreferences();
              _result = provider.getSelectedPlatform();

              if (_result == "whatsapp" ||
                  _result == "gbwhatsapp" ||
                  _result == "businesswhatsapp") {
                return const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Color(0xff085e55),
                  size: 20,
                );
              } else if (_result == "instagram") {
                return const FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Color(0xff085e55),
                  size: 20,
                );
              } else {
                return const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Color(0xff085e55),
                  size: 20,
                );
              }
            }),
          ),
          const SizedBox(
            width: 10,
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => const Help()));
          //   },
          //   child: const Icon(
          //     Icons.help_outline,
          //     color: Color(0xff085e55),
          //     size: 20,
          //   ),
          // ),
          const SizedBox(
            width: 10,
          ),
        ],
        title: Text(
          "Save It",
          style: Theme.of(context).textTheme.headline1,
        ),
        // centerTitle: true,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: const Drawer(
          child: MainDrawer(),
        ),
      ),
      body: SafeArea(
          child: Consumer<FileActions>(builder: (context, provider, _) {
        provider.getSharedPreferences();
        _result = provider.getSelectedPlatform();
        String _tempResult = "";

        if (_result == "" || _result == " " || _result == null) {
          _tempResult = "Whatsapp"; //just incase, code should never reach here
        }

        _loadBannerAd(_tempResult); //the type of banner i should display
        _bannerAd.load();

        bannerTimer = Timer.periodic(const Duration(seconds: 30), (_) {
          if (!_isBannerReady) {
            _loadBannerAd(_tempResult);
            _bannerAd.load();
          }
        });

        if (_result == "instagram" && !widget.isLocal) {
          print("instagram view!!!");
        } else {
          print("Not instagram view");
        }

        // var _function = (_result == "instagram" && !widget.isLocal) ? _adObj.bigBannerAd() : _adObj.smallBannerAd();
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 2,
            ),
            (_result == "instagram" && !widget.isLocal)
                ? Container()
                : Row(
                    // the top navigation showing images/videos
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentPageIndex = 0;
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(5.0),
                                color: (_currentPageIndex == 0)
                                    ? const Color(0xFF085e55)
                                    : Colors.white,
                                boxShadow: (_currentPageIndex == 0)
                                    ? [
                                        const BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.4),
                                            offset: Offset(0, 0), //(x,y)
                                            blurRadius: 1.0,
                                            spreadRadius: 3),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: (_currentPageIndex == 0)
                                    ? const Text("IMAGES",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 19))
                                    : Text(
                                        "IMAGES",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentPageIndex = 1;
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: (_currentPageIndex == 1)
                                  ? const Color(0xFF085e55)
                                  : Colors.white,
                              boxShadow: (_currentPageIndex == 1)
                                  ? [
                                      const BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.4),
                                          offset: Offset(0, 0), //(x,y)
                                          blurRadius: 1.0,
                                          spreadRadius: 3),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: (_currentPageIndex == 1)
                                  ? const Text("VIDEOS",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 19))
                                  : Text(
                                      "VIDEOS",
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            const SizedBox(height: 4),
            (_isBannerReady)
                ? SizedBox(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd))
                : Container()

            // FutureBuilder(
            //     future: _function,
            //     builder: (ctx, snapShot) {
            //       if (snapShot.hasData) {
            //
            //         var banner = snapShot.data as BannerAd;
            //
            //         if (banner.responseInfo == null) {
            //           print ("No response info");
            //           return Container();
            //         }else{
            //         load() async => await banner.load();
            //         load();
            //         return SizedBox(
            //           width: banner.size.width.toDouble(),
            //           height: banner.size.height.toDouble(),
            //           child: AdWidget(ad: banner));}
            //       }
            //       return Container();
            //     }), //display the banner Ad

            ,
            const SizedBox(height: 10),
            Expanded(child: _pages[_currentPageIndex]),
          ],
        );
      })),
    );
  }
}
