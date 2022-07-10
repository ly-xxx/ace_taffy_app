import 'package:dio/dio.dart';

import '../common/constants.dart';
import 'net_check_interceptor.dart';

class BaseNetWork {
  static bool logEnabled = true;

  factory BaseNetWork() => _getInstance()!;

  static BaseNetWork? get instance => _getInstance();
  static BaseNetWork? _instance;
  Dio? dio;
  BaseOptions? options;

  BaseNetWork._internal() {
    dio = Dio()
      ..options = BaseOptions(
          baseUrl: Constants.baseUrl,
          connectTimeout: 30000,
          sendTimeout: 1000 * 60 * 2,
          receiveTimeout: 1000 * 60 * 2,
          responseType: ResponseType.json)
      //网络状态拦截
      //..interceptors.add(NetCheckInterceptor())
      //..interceptors.add(ResponseInterceptor())
      ..interceptors.add(ErrorInterceptor());
    if (logEnabled) {
      dio?.interceptors.add(LogInterceptor(responseBody: true));
    }
  }

  static BaseNetWork? _getInstance() {
    _instance ??= BaseNetWork._internal();
    return _instance;
  }

  static Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) {
    return BaseNetWork.instance!.dio!
        .get(path, queryParameters: queryParameters)
        .catchError((error, stack) {
      throw error;
    });
  }

  static Future<Response<dynamic>> post(String path,
      {Map<String, dynamic>? queryParameters,
      FormData? formData,
      ProgressCallback? onSendProgress}) {
    return BaseNetWork.instance!.dio!
        .post(path,
            queryParameters: queryParameters,
            data: formData,
            onSendProgress: onSendProgress)
        .catchError((error, stack) {
      throw error;
    });
  }

  static Future<Response<dynamic>> put(String path,
      {Map<String, dynamic>? queryParameters,
      FormData? formData,
      ProgressCallback? onSendProgress}) {
    return BaseNetWork.instance!.dio!
        .put(path,
            queryParameters: queryParameters,
            data: formData,
            onSendProgress: onSendProgress)
        .catchError((error, stack) {
      throw error;
    });
  }

  static Future<Response<dynamic>> patch(String path,
      {Map<String, dynamic>? queryParameters,
      FormData? formData,
      ProgressCallback? onSendProgress}) {
    return BaseNetWork.instance!.dio!
        .patch(path,
            queryParameters: queryParameters,
            data: formData,
            onSendProgress: onSendProgress)
        .catchError((error, stack) {
      throw error;
    });
  }

  static Future<Response<dynamic>> delete(String path,
      {Map<String, dynamic>? queryParameters, FormData? formData}) {
    return BaseNetWork.instance!.dio!
        .delete(path, queryParameters: queryParameters, data: formData)
        .catchError((error, stack) {
      throw error;
    });
  }
}

class AceDioError extends DioError {
  @override
  final String error;

  AceDioError({required requestOptions, required this.error})
      : super(requestOptions: requestOptions);
}
