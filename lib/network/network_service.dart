import 'package:ace_taffy/common/toast_provider.dart';
import 'package:ace_taffy/network/structures.dart';
import 'package:dio/dio.dart';

import 'base_api.dart';

class TaffyService {
  static Future<Map<String, dynamic>> getUpdateMessage() async {
    final resp = await BaseNetWork.get('https://ly-xxx.github.io/ace_taffy_app_distribution/update.json');
    return resp.data['info'];
  }

  static Future<String> getFanNub(String mid) async {
    final resp = await BaseNetWork.get('https://api.bilibili.com/x/relation/stat?vmid=$mid');
    return (resp.data['data']['follower'] ?? '114514').toString();
  }

  static Future<Map<String, String>> getPersonalInformation(String mid) async {
    Map<String, String> info = {};
    await BaseNetWork.get('https://api.bilibili.com/x/space/acc/info?mid=$mid').then((resp) {
      info.clear();
      info.addAll({
        'name': resp.data['data']['name'].toString(),
        'face': resp.data['data']['face'].toString(),
        'sign': resp.data['data']['sign'].toString(),
        'liveStatus': resp.data['data']['live_room']['liveStatus'].toString(),
        'liveTitle': resp.data['data']['live_room']['title'].toString(),
        'liveCover': resp.data['data']['live_room']['cover'].toString(),
        'liveWatched': resp.data['data']['live_room']['watched_show']['num'].toString(),
        'liveUrl': resp.data['data']['live_room']['url'].toString(),
      });
    });
    return info;
  }

  static Future<List<Video>> getTaffyVideos(int page, String mid) async {
    List<Video> list = [];
    try {
      await BaseNetWork.get(
              'https://api.bilibili.com/x/web-interface/search/all/v2?page=$page&keyword=$mid')
          .then((resp) {
          List cards = resp.data['data']['result'][10]['data'];
        var pageSize = resp.data['data']['pagesize'];
        for (int i = 0; i < pageSize; i++) {
          if (cards.isEmpty || cards.length <= i) break;
          list.add(Video.fromJson(cards[i]));
        }
      });
    } on DioError catch (e) {
      ToastProvider.error(e.message);
    }
    return list;
  }
}
