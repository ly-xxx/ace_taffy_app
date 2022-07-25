import 'package:ace_taffy/common/preferences_util.dart';
import 'package:ace_taffy/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../common_text_style.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
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
    return WillPopScope(
      onWillPop: () async {
        context.read<VideoModel>().rc.requestRefresh();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              primary: false,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<VideoModel>().rc.requestRefresh();
                },
              ),
              title: Text(
                '设置',
                style: TextUtil.base.black2A.medium.sp(18),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('修改目标uid, 当前${SpUtil.tarUid.get()}'),
                Row(
                  children: [
                    Container(
                        height: 48.sp,
                        width: (MediaQuery.of(context).size.width - 60.w) * 0.6,
                        padding: EdgeInsets.fromLTRB(12.w, 6.w, 0, 6.w),
                        margin: EdgeInsets.fromLTRB(20.w, 0, 10.w, 10.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            boxShadow: shadow),
                        child: TextField(controller: _tc)),
                    GestureDetector(
                      onTap: () {
                        SpUtil.tarUid.set(_tc.text);
                        setState(() {});
                      },
                      child: Container(
                        height: 48.sp,
                        width: (MediaQuery.of(context).size.width - 60.w) * 0.2,
                        padding: EdgeInsets.all(6.w),
                        margin: EdgeInsets.fromLTRB(0, 0, 10.w, 10.w),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 3.4,
                                  spreadRadius: -2,
                                  offset: Offset(0, 0.2))
                            ]),
                        child: Center(
                          child: Text(
                            '修改',
                            style: TextUtil.base.black00.w700.sp(14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        SpUtil.tarUid.clear();
                        setState(() {});
                      },
                      child: Container(
                        height: 48.sp,
                        width: (MediaQuery.of(context).size.width - 60.w) * 0.2,
                        padding: EdgeInsets.all(6.w),
                        margin: EdgeInsets.fromLTRB(0, 0, 20.w, 10.w),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 3.4,
                                  spreadRadius: -2,
                                  offset: Offset(0, 0.2))
                            ]),
                        child: Center(
                          child: Text(
                            '回复',
                            style: TextUtil.base.black00.w700.sp(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
