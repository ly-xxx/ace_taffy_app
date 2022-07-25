import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'network/network_service.dart';
import 'network/structures.dart';

class VideoModel extends ChangeNotifier {
  List<Video> videoList = [];
  int currentPage = 1;

  final RefreshController rc = RefreshController();
  final ScrollController sc = ScrollController();

  void justGetRefreshed() {
    notifyListeners();
  }

  void onRefresh() {
    currentPage = 1;
    videoList.clear();
    rc.refreshCompleted();
    notifyListeners();
  }

  void onLoad() async {
    Future.delayed(const Duration(milliseconds: 5000))
        .whenComplete(() => rc.loadComplete());
    await TaffyService.getTaffyVideos(currentPage, '永雏塔菲')
        .then((List<Video> vd) async {
      videoList.addAll(vd);
      await TaffyService.getTaffyVideos(
              ((currentPage).toDouble() * 2).ceil(), '菲姬厂')
          .then((List<Video> vd) {
        rc.loadComplete();
        if (vd.length >= 20) {
          if (!(currentPage.isOdd)) {
            videoList.addAll(vd.sublist(0, 10));
          } else {
            videoList.addAll(vd.sublist(10, 20));
          }
        }
      });
    });
    currentPage++;
    notifyListeners();
  }
}
