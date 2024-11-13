import 'package:app_template/app/user/model/user_model.dart';
import 'package:app_template/app/user/provider/user_provider.dart';
import 'package:app_template/common/view/root_tab.dart';
import 'package:app_template/login_screen.dart';
import 'package:app_template/splash_screen.dart';
import 'package:app_template/template/sample/adruck/ad_driving_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;
  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (_, state) => const RootTab(),
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/adDriveScreen',
      name: AdDrivingScreen.routeName,
      builder: (_, state) => const AdDrivingScreen(),
    ),
  ];

  void logout(){
    ref.read(userProvider.notifier).logout();
  }

  // SplashScreen
  // 앱을 처음 시작했을때
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정이 필요하다.
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userProvider);

    final logginIn = state.location == '/login' || state.location.contains('signup') || state.location.contains('reset');
    print(state.location);

    // 유저 정보가 없는데 로그인 중이면 그대로 로그인 스크린에
    // 로그인 중이 아니라면 로그인 스크린 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }

    // user가 null이 아님
    // 사용자 정보가 있는 상태면 로그인 중 || 현재 위치가 SplashScreen이면 = 홈으로 이동
    if (user is UserModel) {
      return logginIn || state.location == '/splash' ? '/rootTab' : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }

}