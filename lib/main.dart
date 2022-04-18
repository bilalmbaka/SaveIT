import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../providers/file_actions.dart';
import '../providers/theme_provider.dart';

void main() async {
  // TODO make sure it works for both internal and external storages
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  var _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FileActions>(create: (context) => FileActions()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
        // themeProvider.getSavedTheme(); //get the saved theme from shared preferences.
        // print("The theme is ${themeProvider.themeMode}");

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: AnimatedSplashScreen.withScreenFunction(
              splashIconSize: 100,
              screenFunction: () async {
                _controller.forward();
                return const Home();
              },
              splash: SplashPageAnimation(
                controller: _controller,
              )),
        );
      }),
    );
  }
}

class SplashPageAnimation extends StatefulWidget {
  const SplashPageAnimation({Key? key, required this.controller})
      : super(key: key);

  final AnimationController controller;

  @override
  State<SplashPageAnimation> createState() => _SplashPageAnimationState();
}

class _SplashPageAnimationState extends State<SplashPageAnimation> {
  late final Animation<double?> _flightLeft;
  late final Animation<double?> _flightRight;
  late final Animation<double?> _box;

  @override
  void initState() {
    // TODO: implement initState
    _flightLeft = Tween<double?>(begin: 50, end: 150).animate(CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0, 0.8, curve: Curves.linear)));

    _flightRight = Tween<double?>(begin: 50, end: 150).animate(CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0, 0.8, curve: Curves.linear)));

    _box = Tween<double?>(begin: 10, end: 30).animate(CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.8, 1, curve: Curves.bounceInOut)));

    _flightLeft.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.center,
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                "SAVE IT",
                textStyle:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                speed: const Duration(milliseconds: 500),
              ),
            ],
            onFinished: () {},
          ),
        ),
        Positioned(
          left: _flightLeft.value,
          bottom: 0,
          child: const Icon(
            Icons.send,
            size: 20,
          ),
        ),
        Positioned(
          right: _flightRight.value,
          bottom: 0,
          child: const RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.send,
              size: 20,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _box.value,
              width: 30,
              color: Colors.black,
            ))
      ],
    );
  }
}
