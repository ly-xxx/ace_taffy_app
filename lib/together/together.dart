import 'dart:async';

import 'package:ace_taffy/network/structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/common_text_style.dart';
import '../network/network_service.dart';

class TogetherPage extends StatefulWidget {
  const TogetherPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TogetherPageState();
}

class TogetherPageState extends State<TogetherPage> {
  List<Episode> fullList = [];
  Map<Episode, int> arrangedMap = {};
  Timer? _dateTimer;
  String bvid = "BV1qD4y1q7QY";
  bool useAutoRefresh = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dateTimer?.cancel();
    _dateTimer = null;
    super.dispose();
  }

  void refresh() async {
    fullList.clear();
    await TaffyService.getAllFromVideo(bvid: bvid)
        .then((List<Episode> vd) async {
      fullList.addAll(vd);
    });
    getStatistics();
  }

  void getStatistics() async {
    Map<Episode, int> eMap = {};
    for (Episode e in fullList) {
      await TaffyService.getOnlineNum(aid: e.aid, cid: e.cid).then((onlineNum) {
        eMap.addAll({e: onlineNum});
      });
    }
    arrangedMap = Map.fromEntries(eMap.entries.toList()
      ..sort((e1, e2) => -(e1.value.compareTo(e2.value))));
    setState(() {});
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => SimpleDialog(children: [
                    GestureDetector(
                      onTap: () => useAutoRefresh
                          ? setState(() {
                              useAutoRefresh = false;
                              _dateTimer?.cancel();
                            })
                          : setState(() {
                              useAutoRefresh = true;
                              getStatistics();
                              _dateTimer = Timer.periodic(
                                  const Duration(minutes: 1), (timer) {
                                getStatistics();
                              });
                            }),
                      child: Container(
                        height: 48.sp,
                        width: (MediaQuery.of(context).size.width - 50.w) * 0.4,
                        padding: EdgeInsets.fromLTRB(12.w, 6.w, 0, 6.w),
                        margin: EdgeInsets.fromLTRB(20.w, 0, 10.w, 10.w),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
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
                  ]),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  onPressed: refresh,
                ),
              ],
              title: Text(
                '同接监测',
                style: TextUtil.base.black2A.medium.sp(18),
              ),
            ),
            body: ListView.builder(
                itemCount: arrangedMap.length,
                itemBuilder: (context, index) {
                  return Container(
                      color: Colors.black12,
                      child: Text(arrangedMap.keys.toList()[index].bvid +
                          arrangedMap.values.toList()[index].toString()));
                })));
  }
}
