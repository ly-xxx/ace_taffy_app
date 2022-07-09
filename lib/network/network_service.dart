import 'base_api.dart';

class TaffyService {

  static Future<String> getFanNub(String mid) async {
    final resp = await BaseNetWork.get('x/relation/stat?vmid=$mid');
    return resp.data['data']['follower'].toString();
  }

  static Future<Map<String, String>> getPersonalInformation(String mid) async {
    Map<String, String> info = {};
    await BaseNetWork.get('x/space/acc/info?mid=$mid').then((resp) {
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
}
