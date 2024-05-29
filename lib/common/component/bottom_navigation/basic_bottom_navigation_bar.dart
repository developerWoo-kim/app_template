import 'package:app_template/common/const/colors.dart';
import 'package:flutter/material.dart';

class BasicBottomNavigationBar extends StatelessWidget {
  final Widget content;
  const BasicBottomNavigationBar({
    required this.content,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: BLACK_02,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        // height: 70,
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: content,
            )
          ],
        )
    );
  }
}
