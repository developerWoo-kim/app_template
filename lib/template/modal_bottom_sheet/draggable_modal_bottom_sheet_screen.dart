import 'package:app_template/common/component/modal/draggable_modal_bottom_sheet.dart';
import 'package:app_template/common/component/text/body_text.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:flutter/material.dart';

class DraggableModalBottomSheetScreen extends StatefulWidget {
  const DraggableModalBottomSheetScreen({super.key});

  @override
  State<DraggableModalBottomSheetScreen> createState() => _DraggableModalBottomSheetScreenState();
}

class _DraggableModalBottomSheetScreenState extends State<DraggableModalBottomSheetScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE, title: '드래그 바텀 시트'),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Text("지도"),
          ),
          DraggableModalBottomSheet(
            context: context,
            scrollController: scrollController,
            content: BodyText(title: '', textSize: BodyTextSize.MEDIUM, ),
          )
        ],
      ),
    );
  }
}
