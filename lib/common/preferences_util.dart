import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._();

  static SharedPreferences? _sharedPref;

  // 初始化sharedPrefs，在运行app前被调用
  static Future<void> initSp() async {
    _sharedPref = await SharedPreferences.getInstance();
  }
  static var tarUid = PrefsBean<String>('tarUid', '1265680561');

  static var taffyHomePage = PrefsBean<String>('taffyHomePage', 'https://space.bilibili.com/1265680561');
  static var yeexHomePage = PrefsBean<String>('yeexHomePage', 'https://space.bilibili.com/291386365');

  static var taffyLivePage = PrefsBean<String>('taffyLivePage', 'https://live.bilibili.com/22603245');


  static var lastFansCnt = PrefsBean<String>('lastFansCnt', '555654');
  static var lastLiveViewCnt = PrefsBean<int>('lastLiveViewCnt', 0);
  static var staUrls = PrefsBean<List<String>>('staUrls', [
    'https://space.bilibili.com/1265680561',
    'https://vtbs.moe/detail/1265680561',
    'https://vup.darkflame.ga/ranking/month',
    'https://vup.darkflame.ga/ranking/day',
    'https://playboard.co/en/youtube-ranking/most-popular-v-tuber-channels-in-worldwide-daily'
  ]);
  static var staNames = PrefsBean<List<String>>('staNames', [
    'taffy主页',
    'vtbs.moe',
    'VupLiveChatRecorder-月榜',
    'VupLiveChatRecorder-日榜',
    'playboard'
  ]);
  static var pltUrls = PrefsBean<List<String>>('pltUrls', [
    'https://space.bilibili.com/1265680561/dynamic',
    'https://weibo.com/n/%E6%B0%B8%E9%9B%8F%E5%A1%94%E8%8F%B2',
    'https://v.douyin.com/2dDN4G5/',
    'https://shop249421460.m.taobao.com/',
    'https://www.youtube.com/channel/UC-WTKBWDsp0PFcGmmuO7svg',
    'https://twitter.com/AceTaffy812'
  ]);
  static var pltNames = PrefsBean<List<String>>('pltNames',
      ['bilibili', '微博（浪浪空间）', '抖音（短视频！看一支）', '淘宝（买！）', 'youtube', 'twitter']);
  static var bbsUrls = PrefsBean<List<String>>('bbsUrls', [
    'https://tieba.baidu.com/f?kw=%E6%B0%B8%E9%9B%8F%E5%A1%94%E8%8F%B2',
    'https://tieba.baidu.com/f?kw=%E5%8F%8D%E6%B0%B8%E9%9B%8F%E5%A1%94%E8%8F%B2',
    'https://tieba.baidu.com/f?kw=v',
    'https://www.bilibili.com/h5/channel/4429874',
    'https://www.bilibili.com/h5/channel/860',
    'https://tieba.baidu.com/f?kw=%E7%83%AD%E6%B0%B4%E5%99%A8',
  ]);
  static var bbsNames = PrefsBean<List<String>>('bbsNames', [
    '永雏塔菲吧',
    '反永雏塔菲吧',
    'V吧',
    'bilibili虚拟up主话题',
    'bilibili日本话题',
    '热水器吧',
  ]);

  static void clearAll() {
    lastFansCnt.clear();
    lastLiveViewCnt.clear();
    staUrls.clear();
    staNames.clear();
    pltUrls.clear();
    pltNames.clear();
    bbsUrls.clear();
    bbsNames.clear();
  }
}

class PrefsBean<T> with PreferencesMixin<T> {
  PrefsBean(this._key, [this._default]) {
    _default ??= _getDefaultValue();
  }

  String _key;
  T? _default;

  T get() => _getValue(_key) ?? _default;

  void set(T newValue) => _setValue(newValue, _key);

  void clear() => _clearValue(_key);
}

mixin PreferencesMixin<T> {
  static SharedPreferences? get pref => SpUtil._sharedPref;

  dynamic _getValue(String key) => pref!.get(key);

  void _setValue(T value, String key) async {
    if (value is String) {
      await pref!.setString(key, value);
    } else if (value is bool) {
      await pref!.setBool(key, value);
    } else if (value is int) {
      await pref!.setInt(key, value);
    } else if (value is double) {
      await pref!.setDouble(key, value);
    } else if (value is List<String>) {
      await pref!.setStringList(key, value);
    }
  }

  void _clearValue(String key) async => await pref!.remove(key);

  dynamic _getDefaultValue() {
    switch (T) {
      case String:
        return "";
      case int:
        return 0;
      case double:
        return 0.0;
      case bool:
        return false;
      case List:
        return [];
      default:
        return null;
    }
  }
}
