import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../common/common_text_style.dart';

class DataPlazaEntryPage extends StatefulWidget {
  const DataPlazaEntryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DataPlazaEntryPageState();
}

class DataPlazaEntryPageState extends State<DataPlazaEntryPage>
    with SingleTickerProviderStateMixin {
  late final WebViewController _wc;

  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'V圈数据',
          style: TextUtil.base.black2A.medium.sp(18),
        ),
      ),
      body: SafeArea(
          child: ListView(children: [
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 1.4,
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
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 1.4 - 60.h,
                child: WebView(
                  initialUrl:
                      'https://vup.darkflame.ga/ranking/month?sortby=participant',
                  onWebViewCreated: (webC) {
                    _wc = webC;
                    WidgetsBinding.instance?.addPostFrameCallback((_) =>
                        _wc.loadUrl(
                            'https://vup.darkflame.ga/ranking/month?sortby=participant'));
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                ),
              ),
              SizedBox(
                height: 60.h,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          _wc.goBack();
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Icon(Icons.arrow_forward),
                        onTap: () {
                          _wc.goForward();
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Icon(Icons.refresh),
                        onTap: () {
                          _wc.reload();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]))
      ])),
    );
  }
}
