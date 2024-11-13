
import 'package:app_template/app/user/model/user_model.dart';
import 'package:app_template/app/user/repository/auth_repository.dart';
import 'package:app_template/app/user/repository/member_repository.dart';
import 'package:app_template/common/const/data.dart';
import 'package:app_template/common/secure_storage/secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final memberRepository = ref.watch(memberRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserStateNotifier(
      authRepository: authRepository,
      repository: memberRepository,
      storage: storage
  );
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final MemberRepository repository;
  final FlutterSecureStorage storage;

  UserStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if(refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await repository.findUser();

    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {

    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
          username: username,
          password: password
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.findUser();

      state = userResp;

      const authChannel = MethodChannel('auth_channel');
      await authChannel.invokeMethod('setAuth', {
        'accessToken' : resp.accessToken,
        'refreshToken' : resp.refreshToken
      });

      return userResp;
    } catch(e) {
      String message = '';
      if (e is DioError && e.response != null) {
        message = '${e.response?.data["message"] ?? e.response?.statusMessage ?? "일시적인 오류가 발생하였습니다."}';
      }

      state = UserModelError(message: message);

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;
    final wishList = await storage.read(key: 'WISH_LIST');
    if(wishList != null && wishList != '') {
      await Future.wait([
        repository.saveWish(adSns: wishList),
        storage.delete(key: 'WISH_LIST')
      ]);
    }
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}