import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pages/recent_status.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavSelectedIndex = 0;
  final List<Widget> _bottomNavPages = [
    //the nav pages, first one is for whatsapp status,second for saved files
    const RecentStatus(
      isLocal: false,
    ),
    const RecentStatus(
      isLocal: true,
    ) //,const SettingsPage()
  ];

  Future<bool> checkPermission() async {
    var _status = await Permission.storage.status;

    if (_status != PermissionStatus.granted) {
      var _result = await Permission.storage.request();

      if (_result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkPermission(),
        builder: (ctx, asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.done) {
            if (asyncSnapShot.hasData) {
              var result = asyncSnapShot.data as bool;
              if (result) {
                return Scaffold(
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _bottomNavSelectedIndex,
                    elevation: 100,
                    selectedItemColor: const Color(0xFF20c65a),
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: FaIcon(FontAwesomeIcons.clock),
                          label: "Recent"),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.folder_open),
                        label: "Saved",
                      ),
                      // BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
                    ],
                    onTap: (index) {
                      setState(() {
                        _bottomNavSelectedIndex = index;
                      });
                    },
                  ),
                  body: _bottomNavPages[_bottomNavSelectedIndex],
                );
              } else {
                setState(() {});
              }
            }
          } else {
            return Container();
          }
          return Container();
        });
  }
}
