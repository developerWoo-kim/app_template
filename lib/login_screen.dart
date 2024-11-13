import 'package:app_template/app/user/model/user_model.dart';
import 'package:app_template/app/user/provider/user_provider.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/component/text/custom_text_form_field.dart';
import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/common/utils/snack_bar_util.dart';
import 'package:app_template/template/sample/adruck/ad_driving_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/layout/default_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'loginScreen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  void _showSnackBar(String message) async{
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);

    if(state is UserModelError) {
      _showSnackBar(state.message);
    }

    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.NONE),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '테스트 아이디를 입력해주세요',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: PRIMARY_COLOR_01,
                  ),
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: PRIMARY_COLOR_01,
                  ),
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: state is UserModelLoading
                        ? null
                        : () async {
                      ref.read(userProvider.notifier).login(
                        username: username,
                        password: password,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR_01,
                      foregroundColor: PRIMARY_COLOR_04,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                          color: INPUT_BG_COLOR2
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          title: '자동운행 테스터 로그인',
          textSize: BodyTextSize.LARGE
        ),
      ],
    );
  }
}
