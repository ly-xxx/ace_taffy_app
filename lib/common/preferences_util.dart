import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._();

  static SharedPreferences? _sharedPref;

  // 初始化sharedPrefs，在运行app前被调用
  static Future<void> initSp() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  // 是否正在上传音频，上传中不能调用 check 和 compose
  // static var isUploadingRecord = PrefsBean<bool>('isUploadingRecord', false);


  static void clearAllExceptInstruction() {

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
    } else if (value is List) {
      await pref!.setStringList(key, value as List<String>);
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
