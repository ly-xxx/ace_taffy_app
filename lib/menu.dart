import 'dart:async';
import 'dart:math';

import 'package:ace_taffy/common/constants.dart';
import 'package:ace_taffy/common/preferences_util.dart';
import 'package:ace_taffy/common/webview_widget.dart';
import 'package:ace_taffy/network/network_service.dart';
import 'package:ace_taffy/providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'common/common_text_style.dart';
import 'common/toast_provider.dart';
import 'network/structures.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super();

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  Timer? _dateTimer;
  bool showTopButton = false;

  bool showUpdate = false;

  String updateUrl = '';
  String version = '';
  String updateTime = '';
  String updateContent = '';

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

  static List<BoxShadow> shadow = [
    const BoxShadow(
        color: Colors.black54,
        blurRadius: 3.4,
        spreadRadius: -2,
        offset: Offset(0, 0.2))
  ];

  List<String> assetName = [
    'assets/menu_logo/official_taffy.png',
    'assets/menu_logo/taffy_up_side_down.png',
    'assets/menu_logo/data_plaza.png',
    'assets/menu_logo/crazy_taffy.png',
    'assets/menu_logo/slice.png',
    'assets/menu_logo/yeex_official.png',
  ];
  List<String> identifiedName = ['塔动态', '塔论坛', '塔数据', '塔子说话', '同接监测', '关于'];

  List<String> routes = [
    'OfficialTaffyPage',
    'BBSSPage',
    'DataPlazaEntryPage',
    'TaffySaysPage',
    'TogetherPage',
    'AboutPage'
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

  @override
  void initState() {
    context.read<VideoModel>().sc.addListener(() {
      if (showTopButton) {
        if (context.read<VideoModel>().sc.offset < 1000) {
          setState(() {
            showTopButton = false;
          });
        }
      } else {
        if (context.read<VideoModel>().sc.offset > 1200) {
          setState(() {
            showTopButton = true;
          });
        }
      }
    });
    fanNow = SpUtil.lastFansCnt.get();
    getStatistics();
    getUpdate();
    super.initState();
  }

  @override
  void dispose() {
    context.read<VideoModel>().rc.dispose();
    _dateTimer?.cancel();
    _dateTimer = null;
    super.dispose();
  }

  getUpdate() async {
    await TaffyService.getUpdateMessage().then((message) {
      var versionInfo = message["version"];
      if (versionInfo != null) {
        if (double.parse(versionInfo["versionCode"] ?? "0").toInt() >
            Constants.versionNow) {
          ToastProvider.running('检查到新版本');
          updateUrl = versionInfo["path"];
          updateContent = versionInfo["content"];
          updateTime = versionInfo["time"];
          version = versionInfo["version"];
          setState(() {
            showUpdate = true;
          });
        }
      }
      var links = message["links"];
      if (links != null) {
        SpUtil.taffyHomePage.set(links["taffyHomePage"]);
        SpUtil.yeexHomePage.set(links["yeexHomePage"]);

        List<String> staUrlsList = [];
        for (String url in links["staUrls"]) {
          staUrlsList.add(url);
        }
        SpUtil.staUrls.set(staUrlsList);

        List<String> staNamesList = [];
        for (String url in links["staNames"]) {
          staNamesList.add(url);
        }
        SpUtil.staNames.set(staNamesList);

        List<String> pltUrlsList = [];
        for (String url in links["pltUrls"]) {
          pltUrlsList.add(url);
        }
        SpUtil.pltUrls.set(pltUrlsList);

        List<String> pltNamesList = [];
        for (String url in links["pltNames"]) {
          pltNamesList.add(url);
        }
        SpUtil.pltNames.set(pltNamesList);

        List<String> bbsUrlsList = [];
        for (String url in links["bbsUrls"]) {
          bbsUrlsList.add(url);
        }
        SpUtil.bbsUrls.set(bbsUrlsList);

        List<String> bbsNamesList = [];
        for (String url in links["bbsNames"]) {
          bbsNamesList.add(url);
        }
        SpUtil.bbsNames.set(bbsNamesList);
      }
    });
  }

  getStatistics() async {
    fanNow = await TaffyService.getFanNub(SpUtil.tarUid.get());
    yeexFanNow = await TaffyService.getFanNub('291386365');
    fansChanged = double.parse(fanNow).toInt() -
        double.parse(SpUtil.lastFansCnt.get()).toInt();
    SpUtil.lastFansCnt.set(fanNow);
    await TaffyService.getPersonalInformation(SpUtil.tarUid.get()).then((info) {
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
    context.read<VideoModel>().onRefresh();
  }

  _onLoad() {
    context.read<VideoModel>().onLoad();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      backgroundColor: const Color(0xfffcf8fe),
      floatingActionButton: showTopButton
          ? FloatingActionButton(
              elevation: 5,
              onPressed: () {
                if (context.read<VideoModel>().sc.offset > 2000) {
                  context.read<VideoModel>().sc.jumpTo(1800);
                  context.read<VideoModel>().sc.animateTo(-80,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                } else {
                  context.read<VideoModel>().sc.animateTo(-80,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/icons/svg/rocket.svg',
                    color: Colors.black),
              ),
            )
          : const SizedBox(),
      body: SafeArea(
        child: Column(
          children: [
            Offstage(
              offstage: !showUpdate,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 10.w),
                margin: EdgeInsets.fromLTRB(8.w, 20.w, 8.w, 0),
                decoration: BoxDecoration(
                    color: const Color(0xFF384B44),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    boxShadow: shadow),
                child: GestureDetector(
                  onTap: () async {
                    await launchUrlString(updateUrl,
                        mode: LaunchMode.externalApplication);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '在线更新 ',
                            style: TextUtil.base.white.w700.sp(26),
                          ),
                          Text(
                            '$updateTime 发布',
                            style: TextUtil.base.greyA8.w900.sp(14),
                          ),
                        ],
                      ),
                      Text('点击更新到最新版 v$version',
                          style: TextUtil.base.white.w200.sp(12).h(1.6)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text('更新内容：$updateContent',
                                style: TextUtil.base.white.w400.sp(13).h(1.8)),
                          ),
                          const Spacer(),
                          Text(version,
                              style: TextUtil.base.greyF8.w900.sp(30).h(1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SmartRefresher(
                  physics: const BouncingScrollPhysics(),
                  controller: context.read<VideoModel>().rc,
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
                  enablePullUp: true,
                  onLoading: _onLoad,
                  footer: ClassicFooter(
                    loadingIcon: Image.asset(
                      'assets/menu_logo/taffy_happy.gif',
                      width: 30.h,
                    ),
                    completeDuration: const Duration(milliseconds: 300),
                    idleText: '下拉以刷新 (乀*･ω･)乀',
                    loadingText: topText[Random().nextInt(topText.length)],
                    failedText: '刷新失败（；´д｀）ゞ',
                  ),
                  child: ListView.builder(
                    controller: context.read<VideoModel>().sc,
                    physics: const BouncingScrollPhysics(),
                    itemCount: context.select(
                        (VideoModel model) => model.videoList.length + 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Builder(builder: (context) {
                        if (index == 0) {
                          return head();
                        } else if (index == 1) {
                          return menu();
                        } else if (index == 2) {
                          return Padding(
                            padding: EdgeInsets.only(left: 20.w, top: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '切片二创',
                                      style:
                                          TextUtil.base.black2A.medium.sp(18),
                                    ),
                                    Text(
                                      ' · 根据【永雏塔菲·菲姬厂】关键词搜索',
                                      style: TextUtil.base.greyA6.medium
                                          .sp(12)
                                          .h(2),
                                    ),
                                  ],
                                ),
                                if (context
                                    .read<VideoModel>()
                                    .videoList
                                    .isEmpty)
                                  Text(
                                    '下拉加载喵',
                                    style: TextUtil.base.greyA6.medium
                                        .sp(16)
                                        .h(1.6),
                                  ),
                              ],
                            ),
                          );
                        } else {
                          index = index - 3;
                          return VideoCard(
                              context.select(
                                  (VideoModel model) => model.videoList),
                              index);
                        }
                      });
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget menu() {
    return Column(
      children: List.generate(((identifiedName.length.toDouble()) / 2).floor(),
          (index) {
        // if (index == 0) return sliceCentreEntry();
        // index--;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.w, left: 20.w),
          child: Row(
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
                    setState(() {
                      Navigator.pushNamed(context, routes[index * 2]);
                    });
                  },
                  child: identifiedCard(
                      assetName[index * 2], identifiedName[index * 2]),
                );
              }),
              SizedBox(width: 10.w),
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
                    setState(() {
                      Navigator.pushNamed(context, routes[index * 2 + 1]);
                    });
                  },
                  child: identifiedCard(
                      assetName[index * 2 + 1], identifiedName[index * 2 + 1]),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget head() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await launchUrlString(SpUtil.taffyHomePage.get(),
                mode: LaunchMode.externalApplication);
          },
          child: Container(
            padding: EdgeInsets.all(6.w),
            margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 10.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                boxShadow: shadow),
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
                          if (taffyName == '永雏塔菲')
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
                    child: Image.network(taffyImage,
                        width: 100, fit: BoxFit.fitWidth))
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await launchUrlString(SpUtil.yeexHomePage.get(),
                mode: LaunchMode.externalApplication);
          },
          child: Container(
            padding: EdgeInsets.all(6.w),
            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: shadow),
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
              margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.w),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F9),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: shadow),
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
                                      liveViewerChanged == 0
                                          ? ' '
                                          : '↑$liveViewerChanged',
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
        Row(
          children: [
            GestureDetector(
              onTap: () => useAutoRefresh
                  ? setState(() {
                      useAutoRefresh = false;
                      _dateTimer?.cancel();
                    })
                  : setState(() {
                      useAutoRefresh = true;
                      getStatistics();
                      _dateTimer =
                          Timer.periodic(const Duration(minutes: 1), (timer) {
                        getStatistics();
                      });
                    }),
              child: Container(
                height: 48.sp,
                width: (MediaQuery.of(context).size.width - 50.w) * 0.4,
                padding: EdgeInsets.fromLTRB(12.w, 6.w, 0, 6.w),
                margin: EdgeInsets.fromLTRB(20.w, 0, 10.w, 10.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: shadow),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '切换数据刷新模式',
                      style: TextUtil.base.black00.w700.sp(10),
                    ),
                    Text(
                      !useAutoRefresh ? '当前手动模式' : '当前每分钟刷新',
                      style: TextUtil.base.greyA6.w700.sp(14),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "SettingPage");
              },
              child: Container(
                height: 48.sp,
                width: (MediaQuery.of(context).size.width - 50.w) * 0.6,
                padding: EdgeInsets.all(6.w),
                margin: EdgeInsets.fromLTRB(0, 0, 20.w, 10.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: shadow),
                child: Center(
                  child: Text(
                    '设置',
                    style: TextUtil.base.black00.w700.sp(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget identifiedCard(String assetName, String identifyName) {
    return Container(
      width: (MediaQuery.of(context).size.width - 50.w) * 0.5,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.w)),
          boxShadow: shadow),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16.w)),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.24,
              child: Image.asset(assetName,
                  fit: BoxFit.cover, alignment: Alignment.center),
            ),
            const SizedBox(height: 4),
            Center(
                child: Text(identifyName,
                    style: TextUtil.base.black4E.w500.sp(16))),
            const SizedBox(height: 6)
          ],
        ),
      ),
    );
  }

  Widget sliceCentreEntry() {
    return Container(
      width: MediaQuery.of(context).size.width - 40.w,
      padding: EdgeInsets.fromLTRB(8.w, 8.w, 0, 8.w),
      margin: EdgeInsets.only(bottom: 10.w),
      decoration: BoxDecoration(
          color: const Color(0xFF393939),
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          boxShadow: shadow),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('切片助手', style: TextUtil.base.white.w500.sp(18)),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 118.w,
                    height: (MediaQuery.of(context).size.width - 48.w) * 0.225,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width:
                              (MediaQuery.of(context).size.width - 48.w) * 0.4,
                          height: (MediaQuery.of(context).size.width - 48.w) *
                              0.225,
                          margin: EdgeInsets.fromLTRB(0, 4.w, 8.w, 0),
                          decoration: BoxDecoration(
                              color: const Color(0xFFB7B7B7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.w)),
                              boxShadow: shadow),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, 'SliceHelperPage'),
                    icon: Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 28.sp))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final List<Episode> vid;
  final int indexNow;

  const VideoCard(this.vid, this.indexNow, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  int swiperMinIndex = 0;
  int swiperOffsetIndex = 0;
  bool firstBack = false;
  bool canScroll = true;
  List<Widget> cards = [];
  final ScrollController _controller = ScrollController();

  _VideoCardState();

  @override
  void initState() {
    swiperMinIndex = widget.indexNow;
    super.initState();
  }

  Widget cardSpace(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40.w,
        height: (MediaQuery.of(context).size.width - 40.w) * 0.66 + 50.h,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
            color: widget.vid[widget.indexNow].view >= 100000
                ? (widget.vid[widget.indexNow].like /
                            widget.vid[widget.indexNow].view) >=
                        0.04
                    ? const Color(0xFFFFEAD2)
                    : const Color(0xFFFFF7E6)
                : (widget.vid[widget.indexNow].like /
                            widget.vid[widget.indexNow].view) >=
                        0.04
                    ? const Color(0xFFFDF4FF)
                    : DateTime.now()
                                .difference(DateTime.fromMillisecondsSinceEpoch(
                                    widget.vid[widget.indexNow].pubDate * 1000))
                                .inDays <=
                            1
                        ? const Color(0xFFDEE3FF)
                        : const Color(0xFFFFFFFF),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            boxShadow: MenuPageState.shadow),
        child: GestureDetector(
          onTap: () {
            cards.clear();
            cards.addAll([
              cardSpace(context),
              WebViewCard(
                  0,
                  [
                    "https://www.bilibili.com/video/${widget.vid[swiperMinIndex].bvid}"
                  ],
                  const [''],
                  true),
              WebViewCard(
                  0,
                  [
                    "https://www.bilibili.com/video/${widget.vid[swiperMinIndex + 1].bvid}"
                  ],
                  const [''],
                  true),
              WebViewCard(
                  0,
                  [
                    "https://www.bilibili.com/video/${widget.vid[swiperMinIndex + 2].bvid}"
                  ],
                  const [''],
                  true),
            ]);
            showDialog(
                context: context,
                builder: (_) {
                  return Stack(
                    children: [
                      Positioned(
                        top: -140.h,
                        child: GestureDetector(
                          onTap: () => Navigator.pop,
                          onVerticalDragEnd: (details) {
                            _scrollAction(details);
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height + 140.h,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _controller,
                              children: cards,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: -140.h,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.width - 40.w) *
                                          0.66 +
                                      106.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                    Colors.transparent,
                                    Colors.black87
                                  ])),
                            ),
                          )),
                      Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: scrollDown,
                            onVerticalDragEnd: (details) {
                              _scrollAction(details);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height -
                                  ((MediaQuery.of(context).size.width - 40.w) *
                                          1.32 +
                                      86.h),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Colors.transparent,
                                    Colors.black87
                                  ])),
                            ),
                          )),
                    ],
                  );
                });
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(19)),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black26,
                          width:
                              (MediaQuery.of(context).size.width - 52.w) * 0.6,
                          height: (MediaQuery.of(context).size.width - 52.w) *
                              0.375,
                        ),
                        Image.network(
                          widget.vid[widget.indexNow].pic,
                          cacheHeight: 300,
                          cacheWidth: 480,
                          width: (1.sw - 52.w) * 0.6,
                          height: (1.sw - 52.w) * 0.375,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 6.w,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 0),
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.w))),
                            child: Text(
                              widget.vid[widget.indexNow].duration.toString(),
                              style: TextUtil.base.white.w400.sp(14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(width: 10.w),
                SizedBox(
                  width:
                      (MediaQuery.of(context).size.width - 52.w) * 0.4 - 10.w,
                  height: (MediaQuery.of(context).size.width - 52.w) * 0.375,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                await launchUrlString(
                                    "https://www.bilibili.com/video/${widget.vid[widget.indexNow].bvid}",
                                    mode: LaunchMode
                                        .externalNonBrowserApplication);
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 4.w, 0),
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFC0CB),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    boxShadow: MenuPageState.shadow),
                                child: Center(
                                  child: Text(
                                    'b站打开',
                                    style: TextUtil.base.white.w800.sp(11),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: saveImgToAlbum,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF74C0FF),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    boxShadow: MenuPageState.shadow),
                                child: Center(
                                  child: Text(
                                    '封面下载',
                                    style: TextUtil.base.white.w800.sp(11),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '点击封面直接播放视频',
                        style: TextUtil.base.greyA6.w500.sp(10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        '播放:${widget.vid[widget.indexNow].view} 赞:${widget.vid[widget.indexNow].like}',
                        style: TextUtil.base.greyA6.w500.sp(11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(
                                widget.vid[widget.indexNow].pubDate * 1000)
                            .toString()
                            .substring(0, 19),
                        style: TextUtil.base.greyA6.w500.sp(10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                widget.vid[widget.indexNow].title,
                style: TextUtil.base.black2A.w500.sp(16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ));
  }

  void saveImgToAlbum() {
    final url = widget.vid[widget.indexNow].pic;
    GallerySaver.saveImage(url, albumName: 'ace taffy').then((_) {
      ToastProvider.success("成功保存到相册");
    });
  }

  void _press() {
    const PointerEvent addPointer =
        PointerAddedEvent(pointer: 0, position: Offset(189.7, 327.7));
    const PointerEvent downPointer =
        PointerDownEvent(pointer: 0, position: Offset(189.7, 327.7));
    const PointerEvent upPointer =
        PointerUpEvent(pointer: 0, position: Offset(189.7, 327.7));
    GestureBinding.instance.handlePointerEvent(addPointer);
    GestureBinding.instance.handlePointerEvent(downPointer);
    GestureBinding.instance.handlePointerEvent(upPointer);
  }

  void _scrollAction(DragEndDetails details) {
    if ((details.primaryVelocity ?? 0).abs() >= 30) {
      if (details.primaryVelocity! < 0) {
        // 向下轮播
        scrollDown();
      } else if (swiperOffsetIndex >= 0) {
        // 向上轮播
        scrollUp();
      } else {
        Navigator.pop(context);
      }
    }
  }

  void scrollDown() {
    if (canScroll) {
      canScroll = false;
      swiperOffsetIndex++;
      _controller
          .animateTo(
              _controller.offset +
                  (MediaQuery.of(context).size.width - 40.w) * 0.66 +
                  106.h,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuad)
          .whenComplete(() {
        canScroll = true;
        if (_controller.offset >=
            _controller.position.maxScrollExtent - 200.h) {
          Navigator.pop(context);
          ToastProvider.running('本页视频已全部播放，正在加载下一页内容');
          context.read<VideoModel>().sc.animateTo(
              context.read<VideoModel>().sc.position.maxScrollExtent,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuad);
        }
      });
      cards.add(WebViewCard(
          0,
          [
            "https://www.bilibili.com/video/${widget.vid[swiperMinIndex + swiperOffsetIndex + 2].bvid}"
          ],
          const [''],
          true));
      if (swiperOffsetIndex - 1 >= 0) {
        setState(() {
          cards[swiperOffsetIndex - 1] = cardSpace(context);
        });
      }
    }
  }

  void scrollUp() {
    if (canScroll) {
      canScroll = false;
      swiperOffsetIndex--;
      _controller
          .animateTo(
        _controller.offset -
            ((MediaQuery.of(context).size.width - 40.w) * 0.66 + 106.h),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
      )
          .whenComplete(() {
        canScroll = true;
      });
      Future.delayed(const Duration(milliseconds: 800))
          .then((value) => _press());
      setState(() {
        if (swiperOffsetIndex > 1) {
          cards.removeAt(swiperOffsetIndex - 1);
          cards.insert(
              swiperOffsetIndex - 1,
              WebViewCard(
                  0,
                  [
                    "https://www.bilibili.com/video/${widget.vid[swiperMinIndex + swiperOffsetIndex - 2].bvid}"
                  ],
                  const [''],
                  true));
        }
        cards.removeLast();
      });
    }
  }
}
