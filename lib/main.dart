import 'package:ace_taffy/data_plaza/data_plaza_entry_page.dart';
import 'package:ace_taffy/menu.dart';
import 'package:ace_taffy/official_taffy/official_taffy.dart';
import 'package:ace_taffy/taffy_says/taffy_says_page.dart';
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
      home: const StartUpWidget(),
      routes: <String, WidgetBuilder>{
        "DataPlazaEntryPage": (BuildContext context) =>
            const DataPlazaEntryPage(),
        "TaffySaysPage": (BuildContext context) => const TaffySaysPage(),
        "OfficialTaffyPage": (BuildContext context) => const OfficialTaffyPage(),
      },
      // 滚动组件拉到底时的波浪颜色，之前默认为蓝色
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
      builder: (context, child) {
        TextUtil.init(context);
        SpUtil.initSp();
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
  const StartUpWidget({Key? key}) : super(key: key);

  @override
  _StartUpWidgetState createState() => _StartUpWidgetState();
}

class _StartUpWidgetState extends State<StartUpWidget> with SingleTickerProviderStateMixin{
  bool _open = true;
  bool _openMain = false;
  double _opacity = 1;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        setState(() {
          _openMain = true;
          _opacity = 0;
        });
        Future.delayed(const Duration(milliseconds: 1100))
            .then((value) => setState(() {
                  _open = false;
                }));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Stack(fit: StackFit.expand, children: [
      Container(
        color: const Color(0xFF0F111A),
      ),
      if (_openMain) const MenuPage(),
      if (_open)
        AnimatedOpacity(
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeOutSine,
          opacity: _opacity,
          child: Container(
            color: const Color(0xfffaeeff),
            child: const Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: Image(
                      image: AssetImage('assets/menu_logo/taffy_happy.gif'))),
            ),
          ),
        ),
    ]);
  }
}
