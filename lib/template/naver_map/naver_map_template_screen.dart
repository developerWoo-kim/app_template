import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/third_party/naver/map/model/camera_state.dart';
import 'package:app_template/third_party/naver/map/provider/camera_change_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif/gif.dart';

class NaverMapTemplateScreen extends ConsumerStatefulWidget {
  const NaverMapTemplateScreen({super.key});

  @override
  ConsumerState<NaverMapTemplateScreen> createState() => _NaverMapTemplateScreenState();
}

class _NaverMapTemplateScreenState extends ConsumerState<NaverMapTemplateScreen> with TickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.NONE),
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
                mapType: NMapType.basic,
                locationButtonEnable: true,
                initialCameraPosition: NCameraPosition(
                    target: NLatLng(36.326114, 127.397069),
                    zoom: 15
                ),
                minZoom: 6,
                maxZoom: 16
            ),
            onMapReady: (controller) {
              print(':::: onMapReady');
              ref.read(cameraChangeProvider.notifier).action();
            },
            onCameraChange: (NCameraUpdateReason reason, bool animated) {
              print(':::: onCameraChange');
              ref.read(cameraChangeProvider.notifier).move();
            },
            onCameraIdle: () {
              print(':::: onCameraIdle');
              ref.read(cameraChangeProvider.notifier).stop();
            },
          ),
          /// 카메라 포인터
          _buildCamaraMarker(),
          /// 뒤로 가기 버튼
          _buildBackButton(context),
        ],
      )
    );
  }

  Widget _buildCamaraMarker() {
    final state = ref.watch(cameraChangeProvider);

    if(state is CameraStateAction) {

      return Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          // child: Image.asset(state.state ? 'assets/img/pin_drop_stan_by.png' : 'assets/img/pin_drop.gif',
          //   width: 60,
          //   height: 60,
          // ),
          child: state.state
            ? Image.asset('assets/img/pin_drop_stan_by.png',
                width: 60,
                height: 60,
              )
            : Gif(
                image: AssetImage('assets/img/pin_drop.gif'),
                width: 60,
                height: 60,
                controller: _gifController,
                fps: 30,
                autostart: Autostart.no,
                placeholder: (context) => const CircularProgressIndicator(),
                onFetchCompleted: () {
                  _gifController.reset();
                  _gifController.forward();
                },
              ),
        ),
      );
    }

    return Container();
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 60,
      left: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            width: 30,
            height: 30,
            child: Icon(Icons.arrow_back, )
        ),
      ),
    );
  }
}
