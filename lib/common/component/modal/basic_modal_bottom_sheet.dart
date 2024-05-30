import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

class BasicModalBottomSheet extends StatelessWidget {
  final Widget content;

  const BasicModalBottomSheet({
    required this.content,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            decoration: BoxDecoration(
              color: PRIMARY_COLOR_04,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                _ModalBar(),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: content
                )
              ],
            )
        ),
      ],
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
            color: LINE_CLOR_01,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}
