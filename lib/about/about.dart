import 'package:ace_taffy/common/constants.dart';
import 'package:ace_taffy/common/preferences_util.dart';
import 'package:ace_taffy/common/toast_provider.dart';
import 'package:ace_taffy/common/webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../common/common_text_style.dart';
import '../network/network_service.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
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
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            primary: false,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '关于喵',
              style: TextUtil.base.black2A.medium.sp(18),
            ),
          ),
          body: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await launchUrlString(SpUtil.yeexHomePage.get(),
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
                          child: Image.asset(
                              'assets/menu_logo/yeex_official.png',
                              width: 30,
                              fit: BoxFit.fitWidth)),
                      SizedBox(width: 6.w),
                      Text(
                        '作者 yeex_offcial',
                        style: TextUtil.base.black00.w700.sp(14),
                      ),
                      const Spacer(),
                      Text(
                        '点击跳转bilibili主页喵 ',
                        style: TextUtil.base.black00.w700.sp(14),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await launchUrlString(
                      'https://github.com/ly-xxx/ace_taffy_app',
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
                          child: Image.asset('assets/icons/png/github.png',
                              width: 30, height: 30, fit: BoxFit.fitWidth)),
                      SizedBox(width: 6.w),
                      Text(
                        'Github仓库',
                        style: TextUtil.base.black00.w700.sp(14),
                      ),
                      const Spacer(),
                      Text(
                        '点击跳转喵 ',
                        style: TextUtil.base.black00.w700.sp(14),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: getUpdate,
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
                          child: Image.asset('assets/menu_logo/taffy_happy.gif',
                              width: 30, fit: BoxFit.fitWidth)),
                      SizedBox(width: 6.w),
                      Text(
                        '检查更新/刷新在线数据',
                        style: TextUtil.base.black00.w700.sp(14),
                      ),
                      const Spacer(),
                      Text(
                        '当前版本 ${Constants.versionName}',
                        style: TextUtil.base.black00.w700.sp(14),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Image.asset('assets/icons/png/qrcode.png',
                    width: MediaQuery.of(context).size.width * 0.6),
              )
            ],
          )),
    );
  }

  getUpdate() async {
    await TaffyService.getUpdateMessage().then((message) {
      var versionInfo = message["version"];
      if (versionInfo != null) {
        if (double.parse(versionInfo["versionCode"] ?? "0").toInt() >
            Constants.versionNow) {
          ToastProvider.running('检查到新版本');
          launchUrlString(versionInfo["path"], mode: LaunchMode.externalApplication);
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
      }
    });
  }
}
