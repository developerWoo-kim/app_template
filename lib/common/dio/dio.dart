import 'dart:io';
import 'package:app_template/common/secure_storage/secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const/data.dart';


/// Dio provider로 관리
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref:  ref
    ),
  );

  return dio;
});


class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String platform = Platform.isIOS ? 'ISO' : 'ANDROID';
    options.headers['User-Agent-Platform'] = platform;

    debugPrint('[REQ] [${options.method}] ${options.uri}');
    if(options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $token'
      });
    }

    if(options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $token'
      });
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    // 1) 401 에러 -> 2) 토큰 재발급 시도 -> 3) 새로운 토큰으로 요청
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    debugPrint(refreshToken);
    /** 401 에러만 체킹하여 Access Token 갱신 */
    final isStatus401 = err.response?.statusCode == 401;
    if(isStatus401 && refreshToken != null){
      final dio = Dio();

      try {
        final resp = await dio.post(
            '$ip/api/v1/auth/token',
            options: Options(
                headers: {
                  'authorization' : 'Bearer $refreshToken',
                }
            )
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'authorization' : 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch(e) {

        return handler.reject(e);
      }
    } else {
      return handler.next(err);
    }
  }
}