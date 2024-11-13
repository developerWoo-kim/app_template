import 'package:app_template/common/router/provider/go_router_provider.dart';
import 'package:app_template/common/view/root_tab.dart';
import 'package:app_template/firebase_options.dart';
import 'package:app_template/splash_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NaverMapSdk.instance.initialize(
      clientId: 'o6lc726z5s',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      }
  );

  runApp(
      ProviderScope(
        child: _App()
      )
  );
}

class _App extends ConsumerWidget {
  const _App({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      // route 4.x 필수 옵션
      // routeInformationProvider: router.routeInformationProvider,
      // URI의 쿼리스트링 파라미터를 라우터에서 인식할 수 있게 해줌
      // routeInformationParser: router.routeInformationParser,
      // // 변경된 값으로 실제 어떤 라우트를 보여줄지 정하는 함수
      // routerDelegate: router.routerDelegate,
      // routerConfig: _router,
      theme: ThemeData(
          fontFamily: 'SpoqaHanSansNeo'
      ),
      debugShowCheckedModeBanner: false,
      // home: SplashScreen(),
    );
  }
}
