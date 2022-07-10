import 'dart:async';

import 'package:ace_taffy/common/constants.dart';
import 'package:ace_taffy/common/toast_provider.dart';
import 'package:ace_taffy/data_plaza/data_plaza_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/common_text_style.dart';

class OfficialTaffyPage extends StatefulWidget {
  const OfficialTaffyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OfficialTaffyPageState();
}

class OfficialTaffyPageState extends State<OfficialTaffyPage>
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
                '塔动态',
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
                ToastProvider.error('自定义功能开发中，请耐心等候');
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
                itemCount: Constants.pltUrls.length + 1,
                itemBuilder: (context, index) {
                  return index == Constants.pltUrls.length
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
                      : WebViewCard(index, Constants.pltUrls, Constants.pltName);
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
