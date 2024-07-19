
import 'package:flutter/material.dart';

class BodyTextBox extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color boxColor;
  final double? borderCircular;

  final Icon? icon;

  const BodyTextBox({
    required this.title,
    required this.textColor,
    required this.boxColor,
    this.borderCircular = 5,
    this.icon,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(borderCircular!),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
          child: Row(
            children: [
              if(icon != null)
                _Icon(icon!),
              Text(title,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textColor
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _Icon(Icon icon) {
    return Row(
      children: [
        icon,
        SizedBox(width: 3.0,)
      ],
    );
  }
}