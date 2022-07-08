import 'package:ace_taffy/taffy_says/taffy_says_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/common_text_style.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super();

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  int active = -1;
  List<String> assetName = [
    'asset/menu_logo/crazy_taffy.png',
    'asset/menu_logo/yeex_official.png'
  ];
  List<String> identifiedName = ['活字印刷', '关于'];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      backgroundColor: const Color(0xfff7edff),
      body: Column(
        children: [
          SizedBox(height: 50.h),
          Text('acetaffy',
              textAlign: TextAlign.center,
              style: TextUtil.base.PingFangSc.medium.black4E.sp(20)),
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () => active == index * 2
                            ? Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                return const TaffySaysPage();
                              }))
                            : setState(() {
                                active = index * 2;
                              }),
                        child: identifiedCard(assetName[index * 2],
                            identifiedName[index * 2], active == index * 2),
                      ),
                      MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () => setState(() {
                          active = index * 2 + 1;
                        }),
                        child: identifiedCard(
                            assetName[index * 2 + 1],
                            identifiedName[index * 2 + 1],
                            active == index * 2 + 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget identifiedCard(String assetName, String identifyName, bool active) {
    return AnimatedContainer(
      width: active
          ? MediaQuery.of(context).size.width * 0.42
          : MediaQuery.of(context).size.width * 0.36,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.w)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: -3,
                offset: Offset(4, 5))
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
                  ? MediaQuery.of(context).size.width * 0.38
                  : MediaQuery.of(context).size.width * 0.32,
              child: Image.asset(assetName,
                  fit: BoxFit.cover, alignment: Alignment.topCenter),
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
