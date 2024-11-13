
import 'package:app_template/common/const/data.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/secure_storage/secure_storage_provider.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/login_screen.dart';
import 'package:app_template/template/sample/adruck/ad_driving_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    try{
      final resp = await dio.post(
          '$ip/api/v1/auth/token',
          options: Options(
              headers: {
                'Authorization' : 'Bearer $refreshToken',
              }
          )
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);
      context.goNamed(AdDrivingScreen.routeName);

    }catch(e) {
      context.goNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.NONE),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo/logo.png',
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
