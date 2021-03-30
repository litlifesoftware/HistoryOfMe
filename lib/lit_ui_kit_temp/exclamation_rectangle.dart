import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class ExclamationRectangle extends StatelessWidget {
  final double height;
  final double width;
  const ExclamationRectangle({
    Key? key,
    this.height = 64.0,
    this.width = 64.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: HexColor('#CFCFCF'),
            borderRadius: BorderRadius.all(
              Radius.circular(
                min(height, width) / (4.2),
              ),
            ),
          ),
          child: Icon(
            LitIcons.info,
            size: (min(height, width) / 3),
            color: HexColor(
              '#A3A3A3',
            ),
          ),
        )
      ],
    );
  }
}
