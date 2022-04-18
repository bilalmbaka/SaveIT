import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  final banner =
      "ca-app-pub-3940256099942544/6300978111"; //test Ad // "ca-app-pub-4285444827369918/4826506990"; //real ad
  final intersitial_video = "ca-app-pub-3940256099942544/1033173712";

  Future<BannerAd> bigBannerAd() async {
    print("running the big banner");
    return BannerAd(
        adUnitId: banner,
        size: AdSize.mediumRectangle,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => null,
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();

            print("Failed to load big banner ad $error");
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ));
  }

  Future<BannerAd> smallBannerAd() async {
    print("running the small banner");
    return BannerAd(
        adUnitId: banner,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => null,
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print("Failed to load small banner ad $error");
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ));
  }

// Future<InterstitialAd?> interstitialVideo() async {
//     InterstitialAd? interstitialAd;
//
//     // print ("in intersitital video function");
//
//     await InterstitialAd.load(
//       adUnitId: intersitial_video,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
//         print ("Succeffully got the add");
//         interstitialAd = ad;
//       },
//         onAdFailedToLoad: (LoadAdError error) => print ("Error loading intersitialAd $error"),
//       ),
//     );
//
//     return interstitialAd;
// }
}
