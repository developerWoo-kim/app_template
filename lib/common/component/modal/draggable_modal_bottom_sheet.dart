import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

class DraggableModalBottomSheet extends StatelessWidget {
  final BuildContext context;
  final ScrollController scrollController;
  final Widget content;


  const DraggableModalBottomSheet({
    required this.context,
    required this.content,
    required this.scrollController,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      // 화면 비율로 높이 조정
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
              // height: 1500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.purpleAccent
              ),
              child: content
          ),
        );
      },
    );
  }

  Widget _ModalBar() {
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: LINE_COLOR_01,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}
