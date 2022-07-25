import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'common_pages/loading.dart';
import 'common_text_style.dart';

class WebViewPage extends StatefulWidget {
  final List<String> urlList;
  final List<String> nameList;

  WebViewPage(this.urlList, this.nameList) : super();

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _sc;

  _WebViewPageState();

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
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _sc,
              itemCount: widget.urlList.length + 1,
              itemBuilder: (context, index) {
                return index == widget.urlList.length
                    ? SizedBox(
                        height: 140.h,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            '到底了喵，上下滑动继续循环卡片',
                            style: TextUtil.base.greyA6.w800.sp(14),
                          ),
                        ),
                      )
                    : WebViewCard(
                        index, widget.urlList, widget.nameList, false);
              }),
        ),
        Positioned(
            bottom: 0,
            child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < 0) {
                      // 向下轮播
                      _sc.offset >= _sc.position.maxScrollExtent - 66.h
                          ? _sc.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutQuad)
                          : _sc.animateTo(_sc.offset + 1.sh - 234.h,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutQuad);
                    } else {
                      // 向上轮播
                      _sc.offset <= 66.h
                          ? _sc.animateTo(_sc.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutQuad)
                          : _sc.animateTo(_sc.offset - 1.sh + 234.h,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutQuad);
                    }
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54])),
                  width: 1.sw,
                  height: 155.h,
                ))),
      ],
    );
  }
}

class WebViewCard extends StatefulWidget {
  final int index;
  final bool full;
  final List<String> urlList;
  final List<String> nameList;
  final Color? backgroundColor;

  WebViewCard(this.index, this.urlList, this.nameList, this.full,
      {this.backgroundColor})
      : super();

  @override
  State<StatefulWidget> createState() => _WebViewCardState(this.index);
}

class _WebViewCardState extends State<WebViewCard> {
  late int index;
  double loading = 0;
  bool offstage = false;
  late Color backgroundColor;
  final Completer<WebViewController> _swc = Completer<WebViewController>();

  _WebViewCardState(this.index);

  @override
  initState() {
    backgroundColor = widget.backgroundColor ?? Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.nameList.isNotEmpty)
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
            width: 1.sw - 20.w,
            height: !widget.full ? 1.sh - 290.h : (1.sw - 40.w) * 0.66 + 50.h,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 6.h),
            decoration: BoxDecoration(
                color: !widget.full ? backgroundColor : Colors.white54,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      spreadRadius: -1,
                      offset: Offset(2, 3))
                ]),
            child: Column(children: [
              SizedBox(
                width: 1.sw - 20.w,
                height: !widget.full ? 1.sh - 340.h : (1.sw - 20.w) * 0.66,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2.w),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: WebView(
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
                            if (mounted) {
                              setState(() {
                                loading = 1 / (progress.toDouble() + 1);
                              });
                            }
                          },

                          //加载结束
                          onPageFinished: (_) =>
                              Future.delayed(const Duration(milliseconds: 600))
                                  .then((value) {
                            if (mounted) {
                              setState(() {
                                offstage = true;
                                if (widget.full) {
                                  _press();
                                }
                              });
                            }
                          }),
                          //加载错误
                          onWebResourceError: (WebResourceError error) {},
                        ),
                      ),
                    ),
                    Offstage(
                        offstage: offstage,
                        child: AnimatedOpacity(
                          opacity: 1 - loading,
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeOutCirc,
                          child: Container(
                              color: Colors.black26, child: const Loading()),
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
                              child: Icon(Icons.arrow_back, color: backgroundColor == Colors.white ? Colors.black : Colors.white),
                              onTap: () {
                                controller.data!.goBack();
                              },
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Icon(Icons.arrow_forward, color: backgroundColor == Colors.white ? Colors.black : Colors.white),
                              onTap: () {
                                controller.data!.goForward();
                              },
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Icon(Icons.refresh, color: backgroundColor == Colors.white ? Colors.black : Colors.white),
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
                                margin:
                                    EdgeInsets.fromLTRB(10.h, 10.h, 10.h, 10.h),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFB77FB8),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 2,
                                          spreadRadius: -1,
                                          offset: Offset(1, 2))
                                    ]),
                                child: Center(
                                  child: Text(
                                    'b应用内打开',
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
            ])),
      ],
    );
  }

  void _press() {
    const PointerEvent addPointer =
        PointerAddedEvent(pointer: 0, position: Offset(189.7, 327.7));
    const PointerEvent downPointer =
        PointerDownEvent(pointer: 0, position: Offset(189.7, 327.7));
    const PointerEvent upPointer =
        PointerUpEvent(pointer: 0, position: Offset(189.7, 327.7));
    GestureBinding.instance!.handlePointerEvent(addPointer);
    GestureBinding.instance!.handlePointerEvent(downPointer);
    GestureBinding.instance!.handlePointerEvent(upPointer);
  }
}
