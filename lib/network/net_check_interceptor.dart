import 'package:ace_taffy/common/toast_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../application.dart';
import '../common/common_pages/network_failed_page.dart';
import 'base_api.dart';

class NetCheckInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (NetStatusListener().hasNetwork()) {
      return handler.next(options);
    } else {
      ///跳转网络错误页面
      Navigator.push(Application.key.currentContext!, MaterialPageRoute(
          builder: (BuildContext context) {
        return NetworkFailedPage(is404: false);}));
      throw AceDioError(error: "网络未连接", requestOptions: options);
    }
  }
}

class NetStatusListener {
  static final NetStatusListener _instance = NetStatusListener._();

  NetStatusListener._();

  factory NetStatusListener() => _instance;

  static Future<void> init() async {
    _instance._status = await Connectivity().checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      _instance._status = result;
    });
  }

  ConnectivityResult _status = ConnectivityResult.none;

  bool hasNetwork() => _instance._status != ConnectivityResult.none;
}

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var errorCode = response.data['code'] ?? -1;
    var msg = '';
    switch (errorCode) {
      case '00000': // pass
        break;
      default:
        msg = 'api error ' + errorCode.toString() + (response.data['message'] ?? '');
    }
    if (msg == '') {
      return handler.next(response);
    } else {
      ToastProvider.error(msg);
      return handler.reject(
          AceDioError(error: msg, requestOptions: response.requestOptions));
    }
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  dynamic onError(DioError err, ErrorInterceptorHandler handler) {
    if (err is AceDioError) return err;
    // VoiceDioError不用toast
    ToastProvider.error("onError" + err.message);
    if (err.type == DioErrorType.connectTimeout) {
      _timeout();
      throw DioError(error: "网络连接超时", requestOptions: err.requestOptions);
    } else if (err.type == DioErrorType.sendTimeout) {
      _timeout();
      throw DioError(error: "发送请求超时", requestOptions: err.requestOptions);
    } else if (err.type == DioErrorType.receiveTimeout) {
      _timeout();
      throw DioError(error: "响应超时", requestOptions: err.requestOptions);
    }

    /// 除了以上列出的错误之外，其他的所有错误给一个统一的名称，防止让用户看到奇奇怪怪的错误代码
    else {
      throw DioError(
          error: "err: $err, 发生未知错误，请联系开发人员解决",
          requestOptions: err.requestOptions);
    }
  }

  ///跳转404页面，目前页面结构太乱，有futureBuilder有不是futureBuilder，之后上页面状态管理的话再改掉
  void _timeout() {
    Navigator.push(Application.key.currentContext!, MaterialPageRoute(
        builder: (BuildContext context) {
          return NetworkFailedPage(is404: true);}));
  }
}