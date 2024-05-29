import 'package:app_template/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
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
