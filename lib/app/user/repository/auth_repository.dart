import 'package:app_template/app/user/model/login_response.dart';
import 'package:app_template/app/user/model/token_response.dart';
import 'package:app_template/common/const/data.dart';
import 'package:app_template/common/dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
});

class AuthRepository{
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final resp = await dio.post(
        '$ip/auth/login',
        data: {
          'username' : '$username',
          'password' : '$password'
        }
    );

    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
        '$baseUrl/login',
        options: Options(
            headers: {
              'accessToken': 'true',
            }
        )
    );

    return TokenResponse.fromJson(resp.data);
  }

}