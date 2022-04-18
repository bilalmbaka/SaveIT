import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_saver/providers/file_actions.dart';
import 'package:social_saver/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/ad_helper.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final AdHelper _adObj = AdHelper();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    bool _lightMode = _themeProvider.themeMode!;
    // bool _darkMode = (_themeProvider.themeMode! == 1) ? true : false;
    // print("the value of dakrmode is $_darkMode");

    return Consumer<FileActions>(builder: (context, provider, ch) {
      provider.getSharedPreferences();
      var result = provider.getSelectedPlatform();
      // print ("The value of result is $result");
      if (result == " " || result == null || result == "") {
        result = "Whatsapp";
      }

      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                decoration: const BoxDecoration(
                    color: Color(0xFF20c65a),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(100))),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: (_themeProvider.themeMode!)
                        ? Image.asset("assets/images/save.png")
                        : Image.asset("assets/images/save_white.png"),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Save It",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "A Multi plaform status Saver",
                        softWrap: true,
                        maxLines: 4,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF20c65a)),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () async {
                  // print ("The selected platform is Whatsapp");
                  provider.setSelectedPlatform("Whatsapp");
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    FaIcon(FontAwesomeIcons.whatsapp,
                        color: (result == "Whatsapp")
                            ? const Color(0xFF20c65a)
                            : Colors.black),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "WhatsApp",
                      style: (result == "whatsapp")
                          ? Theme.of(context).textTheme.bodyText1
                          : Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  provider.setSelectedPlatform("businesswhatsapp");
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    FaIcon(FontAwesomeIcons.whatsapp,
                        color: (result == "businesswhatsapp")
                            ? const Color(0xFF20c65a)
                            : Color.fromRGBO(0, 0, 0, 1)),
                    const SizedBox(
                      width: 15,
                    ),
                    Text("WhatsApp Business",
                        style: (result == "businesswhatsapp")
                            ? Theme.of(context).textTheme.bodyText1
                            : Theme.of(context).textTheme.bodyText2)
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  provider.setSelectedPlatform("gbwhatsapp");
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    FaIcon(FontAwesomeIcons.whatsapp,
                        color: (result == "gbwhatsapp")
                            ? const Color(0xFF20c65a)
                            : Colors.black),
                    const SizedBox(
                      width: 15,
                    ),
                    Text("Gb WhatsApp",
                        style: (result == "gbwhatsapp")
                            ? Theme.of(context).textTheme.bodyText1
                            : Theme.of(context).textTheme.bodyText2)
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () async {
                  provider.setSelectedPlatform("instagram");
                  Navigator.of(context).pop();
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (ctx) => InstagramPage()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    FaIcon(FontAwesomeIcons.instagram,
                        color: (result == "instagram")
                            ? const Color(0xFF20c65a)
                            : Colors.black),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Instagram",
                      style: (result == "instagram")
                          ? Theme.of(context).textTheme.bodyText1
                          : Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      //open google play page for rating the app.
                      //TODO update this to the current play store name
                      launch(
                          "https://play.google.com/store/apps/details?id=game.play.wordclass");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.thumbsUp,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Rate Save It",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const FaIcon(
                        FontAwesomeIcons.moon,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Dark Mode",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Switch(
                          activeColor: Colors.black,
                          value: _themeProvider.themeMode!,
                          onChanged: (value) {
                            _themeProvider.saveTheme(value);
                            setState(() {});
                          })
                    ],
                  )
                ],
              ),
              FutureBuilder(
                  future: _adObj.smallBannerAd(),
                  builder: (ctx, snapShot) {
                    if (snapShot.hasData) {
                      var banner = snapShot.data as BannerAd;
                      load() async => await banner
                          .load(); //load the banner ad so it can be displayed
                      load();
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          width: double.infinity,
                          height: 60,
                          child: AdWidget(ad: banner)); //display the banner Ad
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      );
    });
  }
}
