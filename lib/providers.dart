import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'network/network_service.dart';
import 'network/structures.dart';

class VideoModel extends ChangeNotifier {
  List<Episode> videoList = [];
  List<Episode> fullList = [];
  int currentPage = 1;

  final RefreshController rc = RefreshController();
  final ScrollController sc = ScrollController();

  void justGetRefreshed() {
    notifyListeners();
  }

  void onRefresh() {
    currentPage = 1;
    fullList.clear();
    videoList.clear();
    rc.refreshCompleted();
    notifyListeners();
  }

  void onLoad() async {
    if (fullList.isEmpty) {
      Future.delayed(const Duration(milliseconds: 5000))
          .whenComplete(() => rc.loadComplete());
      await TaffyService.getAllFromVideo(bvid: "BV1qD4y1q7QY")
          .then((List<Episode> vd) async {
        fullList.addAll(vd);
        videoList = fullList.length >= 20 ? fullList.sublist(0, 20) : fullList;
        rc.loadComplete();
      });
    } else if (fullList.length >= 10 * currentPage + 10) {
      videoList.addAll(fullList.sublist(currentPage * 10, currentPage * 10 + 10));
      currentPage++;
    }
    rc.loadComplete();
    notifyListeners();
  }
}
