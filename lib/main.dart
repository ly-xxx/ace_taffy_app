import 'package:ace_taffy/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'application.dart';
import 'common/common_text_style.dart';
import 'common/preferences_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final messageChannel = const MethodChannel('com.elderly.taffy/message');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '永雏塔菲',
      debugShowCheckedModeBanner: false,
      home: StartUpWidget(),
      // 滚动组件拉到底时的波浪颜色，之前默认为蓝色
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
      builder: (context, child) {
        TextUtil.init(context);
        final size = MediaQuery.of(context).size;
        Application.screenWidth = size.width;
        Application.screenHeight = size.height;
        Application.statusBarHeight = MediaQuery.of(context).padding.top;
        Application.bottomBarHeight = MediaQuery.of(context).padding.bottom;
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        );
      },
    );
  }
}

class StartUpWidget extends StatefulWidget {
  @override
  _StartUpWidgetState createState() => _StartUpWidgetState();
}

class _StartUpWidgetState extends State<StartUpWidget> {
  bool _open = false;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _open = false;
    _opacity = 0;
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 1000)).then((_) {
        setState(() {
          _open = true;
          _opacity = 1;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Container(
      color: const Color(0xFF0F111A),
      child: Stack(fit: StackFit.expand, children: [
        Container(
          color: const Color(0xfff7ddff),
          child: const Center(
            child: ClipRRect(
                child: Image(
                    image: AssetImage('asset/menu_logo/taffy_happy.gif'))),
          ),
        ),
        if (_open)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeOutSine,
            opacity: _opacity,
            child: const MenuPage(),
          ),
      ]),
      constraints: const BoxConstraints.expand(),
    );
  }
}
