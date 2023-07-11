import 'package:ace_taffy/about/about.dart';
import 'package:ace_taffy/bbss/bbs_page.dart';
import 'package:ace_taffy/common/common_pages/setting.dart';
import 'package:ace_taffy/data_plaza/data_plaza_entry_page.dart';
import 'package:ace_taffy/menu.dart';
import 'package:ace_taffy/official_taffy/official_taffy.dart';
import 'package:ace_taffy/providers.dart';
import 'package:ace_taffy/slice_helper/slice_helper_page.dart';
import 'package:ace_taffy/taffy_says/taffy_says_page.dart';
import 'package:ace_taffy/together/together.dart';
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

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Slicer()
    ),
  );
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoModel()),
      ],
      child: MaterialApp(
        title: 'taffy的小房子',
        debugShowCheckedModeBanner: false,
        home: const StartUpWidget(),
        routes: <String, WidgetBuilder>{
          "DataPlazaEntryPage": (BuildContext context) =>
              const DataPlazaEntryPage(),
          "TaffySaysPage": (BuildContext context) => const TaffySaysPage(),
          "OfficialTaffyPage": (BuildContext context) =>
              const OfficialTaffyPage(),
          "BBSSPage": (BuildContext context) => const BBSSPage(),
          "AboutPage": (BuildContext context) => const AboutPage(),
          "SettingPage": (BuildContext context) => const SettingPage(),
          "SliceHelperPage": (BuildContext context) => const SliceHelperPage(),
          "TogetherPage": (BuildContext context) => const TogetherPage(),
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
          return child!;
        },
      ),
    );
  }
}

class StartUpWidget extends StatefulWidget {
  const StartUpWidget({Key? key}) : super(key: key);

  @override
  _StartUpWidgetState createState() => _StartUpWidgetState();
}

class _StartUpWidgetState extends State<StartUpWidget>
    with SingleTickerProviderStateMixin {
  bool _open = true;
  bool _openMain = false;
  double _opacity = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _opacity = 1;
      });
      Future.delayed(const Duration(milliseconds: 800)).then((_) {
        setState(() {
          _openMain = true;
          _opacity = 0;
        });
        Future.delayed(const Duration(milliseconds: 800))
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
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutSine,
          opacity: _opacity,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.black87,
                image: DecorationImage(
                  image: AssetImage('assets/icons/png/splash.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                )),
          ),
        ),
    ]);
  }
}
