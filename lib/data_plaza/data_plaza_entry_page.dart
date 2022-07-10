import 'dart:async';

import 'package:ace_taffy/common/constants.dart';
import 'package:ace_taffy/common/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../common/common_pages/loading.dart';
import '../common/common_text_style.dart';

class DataPlazaEntryPage extends StatefulWidget {
  const DataPlazaEntryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DataPlazaEntryPageState();
}

class DataPlazaEntryPageState extends State<DataPlazaEntryPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _sc;

  @override
  void initState() {
    _sc = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    //_wc.clear();
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
          title: Row(
            children: [
              Text(
                '数据看板',
                style: TextUtil.base.black2A.medium.sp(18),
              ),
              Text(
                '（点击右下角切换卡片）',
                style: TextUtil.base.black4E60.medium.sp(14),
              ),
            ],
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20.w),
              onPressed: () {
                ToastProvider.error('看板页面自定义功能开发中，请耐心等候');
              },
              icon: Icon(Icons.edit, color: Colors.black, size: 18.sp),
            )
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _sc,
                itemCount: Constants.staUrls.length + 1,
                itemBuilder: (context, index) {
                  return index == Constants.staUrls.length
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height -
                              160.h -
                              MediaQuery.of(context).size.width * 1.3,
                          child: SizedBox(
                            height: 50.h,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                '到底了喵，点击按钮继续循环卡片',
                                style: TextUtil.base.greyA6.w800.sp(14),
                              ),
                            ),
                          ),
                        )
                      : WebViewCard(
                          index, Constants.staUrls, Constants.staName);
                }),
            Positioned(
              bottom: 14.w,
              right: 14.w,
              child: Column(
                children: [
                  FloatingActionButton(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white70,
                    elevation: 10,
                    child: const Icon(Icons.arrow_circle_up_rounded),
                    onPressed: () {
                      _sc.offset <= 66.h
                          ? _sc.animateTo(_sc.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutQuad)
                          : _sc.animateTo(
                              _sc.offset -
                                  MediaQuery.of(context).size.width * 1.3 -
                                  66.h,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutQuad);
                    },
                  ),
                  SizedBox(height: 10.w),
                  FloatingActionButton(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black54,
                    elevation: 10,
                    child: const Icon(Icons.arrow_circle_down_rounded),
                    onPressed: () {
                      _sc.offset >= _sc.position.maxScrollExtent - 66.h
                          ? _sc.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutQuad)
                          : _sc.animateTo(
                              _sc.offset +
                                  MediaQuery.of(context).size.width * 1.3 +
                                  66.h,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutQuad);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewCard extends StatefulWidget {
  final int index;
  final List<String> urlList;
  final List<String> nameList;

  WebViewCard(this.index, this.urlList, this.nameList) : super();

  @override
  State<StatefulWidget> createState() => _WebViewCardState(this.index);
}

class _WebViewCardState extends State<WebViewCard> {
  late int index;
  double loading = 0;
  bool offstage = false;
  final Completer<WebViewController> _swc = Completer<WebViewController>();

  _WebViewCardState(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: SizedBox(
            height: 50.h,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                index < widget.nameList.length
                    ? widget.nameList[index]
                    : widget.urlList[index],
                style: TextUtil.base.black00.w800.sp(18),
              ),
            ),
          ),
        ),
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 1.3,
            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
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
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              child: Column(children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 1.3 - 50.h,
                  child: Stack(
                    children: [
                      WebView(
                        initialUrl: widget.urlList[index],
                        onWebViewCreated: (WebViewController webC) {
                          _swc.complete(webC);
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureNavigationEnabled: true,

                        onPageStarted: (_) => setState(() {
                          offstage = false;
                        }),
                        onProgress: (int progress) {
                          setState(() {
                            loading = 1 / (progress.toDouble() + 1);
                            print(loading);
                          });
                        },

                        //加载结束
                        onPageFinished: (_) =>
                            Future.delayed(const Duration(milliseconds: 600))
                                .then((value) => setState(() {
                                      offstage = true;
                                    })),
                        //加载错误
                        onWebResourceError: (WebResourceError error) {},
                      ),
                      Offstage(
                          offstage: offstage,
                          child: AnimatedOpacity(
                            opacity: 1 - loading,
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.easeOutCirc,
                            child: Container(color: Colors.black26, child: const Loading()),
                          ))
                    ],
                  ),
                ),
                FutureBuilder<WebViewController>(
                    future: _swc.future,
                    builder: (BuildContext context,
                        AsyncSnapshot<WebViewController> controller) {
                      return SizedBox(
                        height: 50.h,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                child: const Icon(Icons.arrow_back),
                                onTap: () {
                                  controller.data!.goBack();
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  controller.data!.goForward();
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: const Icon(Icons.refresh),
                                onTap: () {
                                  controller.data!.reload();
                                },
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  await launchUrlString(widget.urlList[index],
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                  width: 30.w,
                                  height: 30.h,
                                  margin: EdgeInsets.fromLTRB(
                                      10.h, 10.h, 10.h, 10.h),
                                  decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2,
                                            spreadRadius: -1,
                                            offset: Offset(1, 2))
                                      ]),
                                  child: Center(
                                    child: Text(
                                      '浏览器中打开',
                                      style: TextUtil.base.white.w800.sp(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ]),
            )),
      ],
    );
  }
}
