import 'dart:async';
import 'dart:math';

import 'package:ace_taffy/common/constants.dart';
import 'package:ace_taffy/common/preferences_util.dart';
import 'package:ace_taffy/network/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'common/common_text_style.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super();

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  Timer? _dateTimer;

  int active = -1;
  String fanNow = '000000';
  String taffyName = '永雏塔菲';
  String taffySign = '来自1885年的现役偶像！王牌级gamer！商务…@cherrynova.net （没有任何群）';
  String taffyImage =
      'http://i1.hdslb.com/bfs/face/4907464999fbf2f2a6f9cc8b7352fceb6b3bfec3.jpg';
  bool isStreaming = false;
  String liveTitle = '永雏塔菲的直播间';
  String liveCover = '';
  String liveWatched = '0';
  String liveUrl = 'https://bilibili.com/';
  int fansChanged = 0;
  int liveViewerChanged = 0;
  bool useAutoRefresh = false;

  String yeexFanNow = '000000';
  String yeexName = '永雏塔菲';
  String yeexImage =
      'http://i1.hdslb.com/bfs/face/4907464999fbf2f2a6f9cc8b7352fceb6b3bfec3.jpg';

  List<String> assetName = [
    'assets/menu_logo/official_taffy.png',
    'assets/menu_logo/taffy_up_side_down.png',
    'assets/menu_logo/data_plaza.png',
    'assets/menu_logo/crazy_taffy.png',
    'assets/menu_logo/slice.png',
    'assets/menu_logo/yeex_official.png',
  ];
  List<String> identifiedName = ['塔动态', '塔论坛', '塔数据', '塔子说话', '切片二创', '关于'];

  List<String> routes = [
    'OfficialTaffyPage',
    'TaffySaysPage',
    'DataPlazaEntryPage',
    'TaffySaysPage',
    'TaffySaysPage',
    'TaffySaysPage'
  ];

  List<String> topText = [
    "正在刷新喵",
    '关注永雏塔菲喵',
    '关注永雏塔菲谢谢喵',
    '你就是老头？',
    '晚上花',
    '举办永雏塔菲喵'
  ];

  Image face = Image.network(
      'http://i1.hdslb.com/bfs/face/4907464999fbf2f2a6f9cc8b7352fceb6b3bfec3.jpg',
      width: 100.w,
      fit: BoxFit.fitWidth);

  final RefreshController _rc = RefreshController();

  @override
  void initState() {
    fanNow = SpUtil.lastFansCnt.get();
    getStatistics();
    face = Image.network(taffyImage, width: 100, fit: BoxFit.fitWidth);
    super.initState();
  }

  @override
  void dispose() {
    _rc.dispose();
    _dateTimer?.cancel();
    _dateTimer = null;
    super.dispose();
  }

  void getStatistics() async {
    fanNow = await TaffyService.getFanNub('1265680561');
    yeexFanNow = await TaffyService.getFanNub('291386365');
    fansChanged = double.parse(fanNow).toInt() -
        double.parse(SpUtil.lastFansCnt.get()).toInt();
    SpUtil.lastFansCnt.set(fanNow);
    await TaffyService.getPersonalInformation('1265680561').then((info) {
      taffyName = info['name'] ?? '永雏塔菲';
      taffySign = info['sign'] ?? '签名加载失败';
      taffyImage = info['face'] ??
          'http://i1.hdslb.com/bfs/face/4907464999fbf2f2a6f9cc8b7352fceb6b3bfec3.jpg';
      isStreaming = info['liveStatus'] == '1';
      liveTitle = info['liveTitle'] ?? '永雏塔菲的直播间';
      liveCover = info['liveCover'] ?? '';
      liveWatched = info['liveWatched'] ?? '0';
      liveUrl = info['liveUrl'] ?? 'https://bilibili.com/';
      liveViewerChanged =
          double.parse(liveWatched).toInt() - SpUtil.lastLiveViewCnt.get();
      SpUtil.lastLiveViewCnt.set(double.parse(liveWatched).toInt());
    });
    await TaffyService.getPersonalInformation('291386365').then((info) {
      yeexName = info['name'] ?? 'yeex';
      yeexImage = info['face'] ??
          'http://i1.hdslb.com/bfs/face/4907464999fbf2f2a6f9cc8b7352fceb6b3bfec3.jpg';
    });
    setState(() {});
    _rc.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      backgroundColor: const Color(0xfff9f4ff),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => setState(() {
            active = -1;
          }),
          child: SmartRefresher(
              physics: const BouncingScrollPhysics(),
              controller: _rc,
              header: ClassicHeader(
                refreshingIcon: Image.asset(
                  'assets/menu_logo/taffy_happy.gif',
                  width: 30.h,
                ),
                completeDuration: const Duration(milliseconds: 300),
                idleText: '下拉以刷新 (乀*･ω･)乀',
                releaseText: '下拉以刷新',
                refreshingText: topText[Random().nextInt(topText.length)],
                completeText: '刷新完成 (ﾉ*･ω･)ﾉ',
                failedText: '刷新失败（；´д｀）ゞ',
              ),
              cacheExtent: 11,
              enablePullDown: true,
              onRefresh: getStatistics,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ((identifiedName.length.toDouble()) / 2).floor() + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return head();
                  } else {
                    index--;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Builder(builder: (context) {
                            return MaterialButton(
                              padding: EdgeInsets.zero,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  useAutoRefresh = false;
                                  _dateTimer?.cancel();
                                });
                                active == index * 2
                                    ? Navigator.pushNamed(
                                        context, routes[index * 2])
                                    : setState(() {
                                        active = index * 2;
                                      });
                              },
                              child: identifiedCard(
                                  assetName[index * 2],
                                  identifiedName[index * 2],
                                  active == index * 2),
                            );
                          }),
                          Builder(builder: (context) {
                            return MaterialButton(
                              padding: EdgeInsets.zero,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  useAutoRefresh = false;
                                  _dateTimer?.cancel();
                                });
                                active == index * 2 + 1
                                    ? Navigator.pushNamed(
                                        context, routes[index * 2 + 1])
                                    : setState(() {
                                        active = index * 2 + 1;
                                      });
                              },
                              child: identifiedCard(
                                  assetName[index * 2 + 1],
                                  identifiedName[index * 2 + 1],
                                  active == index * 2 + 1),
                            );
                          }),
                        ],
                      ),
                    );
                  }
                },
              )),
        ),
      ),
    );
  }

  Widget head() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await launchUrlString(Constants.taffyHomePage,
                mode: LaunchMode.externalApplication);
          },
          child: Container(
            padding: EdgeInsets.all(6.w),
            margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 18.w),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      spreadRadius: -1,
                      offset: Offset(2, 3))
                ]),
            child: Row(
              children: [
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            taffyName,
                            style: TextUtil.base.black00.w700.sp(22),
                          ),
                          Text(
                            ' Ace Taffy',
                            style: TextUtil.base.greyA8.w900.sp(18),
                          ),
                        ],
                      ),
                      Text(
                          '${taffySign.substring(0, min(taffySign.length, 13))}${taffySign.length > 13 ? '...' : ''}'),
                      Row(children: [
                        Text(
                          'FAN\nCNT ',
                          style: TextUtil.base.black00.w400.sp(14),
                        ),
                        Text(
                          fanNow,
                          style: TextUtil.base.black00.w800.sp(40),
                        ),
                        if (fansChanged != 0)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '\n ${fansChanged > 0 ? '+' : ''}${fansChanged.toString()}',
                              style: TextUtil.base.greyA6.w900.sp(14),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.w)),
                    child: face)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await launchUrlString(Constants.yeexHomePage,
                mode: LaunchMode.externalApplication);
          },
          child: Container(
            padding: EdgeInsets.all(6.w),
            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.w),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      spreadRadius: -1,
                      offset: Offset(2, 3))
                ]),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15.w)),
                    child: Image.network(yeexImage,
                        width: 30, fit: BoxFit.fitWidth)),
                SizedBox(width: 6.w),
                Text(
                  '作者 $yeexName',
                  style: TextUtil.base.black00.w700.sp(14),
                ),
                const Spacer(),
                Text(
                  'FO $yeexFanNow ',
                  style: TextUtil.base.black00.w700.sp(14),
                ),
              ],
            ),
          ),
        ),
        if (isStreaming)
          GestureDetector(
            onTap: () async {
              await launchUrlString(liveUrl,
                  mode: LaunchMode.externalApplication);
            },
            child: Container(
              padding: EdgeInsets.all(6.w),
              margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
              decoration: const BoxDecoration(
                  color: Color(0xFFFFF9F9),
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 5,
                        spreadRadius: -1,
                        offset: Offset(2, 3))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.w)),
                    child: Image.network(
                      liveCover,
                      width: (MediaQuery.of(context).size.width - 62.w) * 0.52,
                      height: (MediaQuery.of(context).size.width - 62.w) * 0.32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 62.w) * 0.48,
                    height: (MediaQuery.of(context).size.width - 62.w) * 0.32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: (MediaQuery.of(context).size.width -
                                          62.w) *
                                      0.32),
                              child: Text(
                                liveTitle,
                                overflow: TextOverflow.ellipsis,
                                style: TextUtil.base.black00.w700.sp(18),
                              ),
                            ),
                            Text(
                              ' 直播中',
                              style: TextUtil.base.liveRed.w900.sp(14),
                            ),
                          ],
                        ),
                        Text('点击跳转直播间',
                            style: TextUtil.base.greyA8.w300.sp(10)),
                        const Spacer(),
                        SizedBox(
                          width:
                              (MediaQuery.of(context).size.width - 62.w) * 0.48,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${liveViewerChanged == 0 ? ' ' : '↑'}$liveViewerChanged',
                                      style: TextUtil.base.greyA6.w900.sp(10),
                                    ),
                                    Text(
                                      liveWatched,
                                      style: TextUtil.base.black00.w900.sp(20),
                                    ),
                                  ],
                                ),
                                Text(
                                  ' VEW\n CNT ',
                                  style: TextUtil.base.black00.w400.sp(14),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        GestureDetector(
          onTap: () => useAutoRefresh
              ? setState(() {
                  active = -1;
                  useAutoRefresh = false;
                  _dateTimer?.cancel();
                })
              : setState(() {
                  active = -1;
                  useAutoRefresh = true;
                  getStatistics();
                  _dateTimer =
                      Timer.periodic(const Duration(minutes: 1), (timer) {
                    getStatistics();
                  });
                }),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.w),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      spreadRadius: -1,
                      offset: Offset(2, 3))
                ]),
            child: Center(
              child: Text(
                !useAutoRefresh ? '切换数据刷新模式，当前手动模式' : '切换数据刷新模式，当前每分钟刷新一次',
                style: TextUtil.base.black00.w700.sp(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget identifiedCard(String assetName, String identifyName, bool active) {
    return AnimatedContainer(
      width: active
          ? MediaQuery.of(context).size.width * 0.42
          : MediaQuery.of(context).size.width * 0.40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.w)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                spreadRadius: -1,
                offset: Offset(2, 3))
          ]),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16.w)),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: active
                  ? MediaQuery.of(context).size.width * 0.26
                  : MediaQuery.of(context).size.width * 0.24,
              child: Image.asset(assetName,
                  fit: BoxFit.cover, alignment: Alignment.center),
            ),
            const SizedBox(height: 4),
            Center(
                child: Text(
              identifyName,
              style: active
                  ? TextUtil.base.black4E.w500.sp(16)
                  : TextUtil.base.greyA6.w500.sp(16),
            )),
            const SizedBox(height: 6)
          ],
        ),
      ),
    );
  }
}
