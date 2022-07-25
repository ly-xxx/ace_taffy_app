import 'package:ace_taffy/common/common_text_style.dart';
import 'package:ace_taffy/common/preferences_util.dart';
import 'package:ace_taffy/common/webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliceHelperPage extends StatefulWidget {
  const SliceHelperPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SliceHelperPageState();
}

class SliceHelperPageState extends State<SliceHelperPage> {
  static List<BoxShadow> shadow = [
    const BoxShadow(
        color: Colors.black54,
        blurRadius: 3.4,
        spreadRadius: -2,
        offset: Offset(0, 0.2))
  ];

  final TextEditingController _tc = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            primary: false,
            backgroundColor: const Color(0xFF1C1C1C),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              '切片助手',
              style: TextUtil.base.white.medium.sp(18),
            ),
          ),
          backgroundColor: const Color(0xFF393939),
          body: Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return top();
                }
                index--;
                return Container(
                    width: MediaQuery.of(context).size.width - 20.w,
                    height: (MediaQuery.of(context).size.width - 20.w) / 16 * 9,
                    padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 4.w),
                    margin: EdgeInsets.only(bottom: 10.w),
                    decoration: BoxDecoration(
                        color: const Color(0xFF8D8D8D),
                        borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        boxShadow: shadow),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.w))));
              },
            ),
          )),
    );
  }

  Widget top() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('① 直播画面预览', style: TextUtil.base.white.w300.sp(22)),
        SizedBox(height: 10.h),
        // WebViewCard(0, [SpUtil.taffyLivePage.get()], const [], false,
        //     backgroundColor: const Color(0xFF150E1A)),
        Text('② 截取精彩时刻', style: TextUtil.base.white.w300.sp(22)),
        GestureDetector(
          onTap: () async {
            await FlutterOverlayWindow.isPermissionGranted()
                .then((permission) async {
              if (permission) {
                if (await FlutterOverlayWindow.isActive()) return;
                await FlutterOverlayWindow.showOverlay(
                  enableDrag: true,
                  overlayTitle: "切片工具",
                  overlayContent: 'Overlay Enabled',
                  flag: OverlayFlag.defaultFlag,
                  alignment: OverlayAlignment.centerLeft,
                  visibility: NotificationVisibility.visibilityPrivate,
                  positionGravity: PositionGravity.auto,
                  width: 260,
                  height: 120,
                );
              } else {
                await FlutterOverlayWindow.requestPermission();
              }
            });
          },
          child: Container(
              width: MediaQuery.of(context).size.width - 20.w,
              height: 80.h,
              padding: EdgeInsets.fromLTRB(4.w, 4.w, 20.w, 4.w),
              margin: EdgeInsets.only(top: 6.w, bottom: 10.w),
              decoration: BoxDecoration(
                  color: const Color(0xFF6A6A6A),
                  borderRadius: BorderRadius.all(Radius.circular(12.w)),
                  boxShadow: shadow),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Image.asset('assets/icons/png/screenshot.png',
                        color: Colors.white),
                  ),
                  const Spacer(),
                  Text('进入浮窗模式↗', style: TextUtil.base.white.w600.sp(20)),
                ],
              )),
        ),
        Text('③ 精彩时刻编辑', style: TextUtil.base.white.w300.sp(22)),
        Container(
            width: MediaQuery.of(context).size.width - 20.w,
            height: 80.h,
            padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 4.w),
            margin: EdgeInsets.only(top: 6.w, bottom: 10.w),
            decoration: BoxDecoration(
                color: const Color(0xFF6A6A6A),
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
                boxShadow: shadow),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.w)))),
        Text('④ 录播视频回查', style: TextUtil.base.white.w300.sp(22)),
        Container(
            width: MediaQuery.of(context).size.width - 20.w,
            height: 80.h,
            padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 4.w),
            margin: EdgeInsets.only(top: 6.w, bottom: 10.w),
            decoration: BoxDecoration(
                color: const Color(0xFF6A6A6A),
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
                boxShadow: shadow),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.w)))),
        Text('⑤ 切片经验分享', style: TextUtil.base.white.w300.sp(22)),
        SizedBox(height: 10.w)
      ],
    );
  }
}

class Slicer extends StatelessWidget {
  const Slicer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FlutterOverlayWindow.closeOverlay();
      },
      child: Container(
        width: 240,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/icons/png/screenshot.png',
                  color: Colors.white, width: 20, fit: BoxFit.fitWidth,),
              const Text('截图', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          )),
    );
  }
}
