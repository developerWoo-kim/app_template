import 'package:app_template/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
      clientId: 'o6lc726z5s',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      }
  );

  runApp(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'SpoqaHanSansNeo'
          ),
          home: const RootTab(),
          debugShowCheckedModeBanner: false,
        ),
      )
  );
}
