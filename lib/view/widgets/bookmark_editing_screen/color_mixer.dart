import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class ColorMixer extends StatelessWidget {
  final int? alphaChannel;
  final int? redChannel;
  final int? greenChanne;
  final int? blueChannel;
  final void Function(double) onAlphaChannelChange;
  final void Function(double) onRedColorChannelChange;
  final void Function(double) onGreenColorChannelChange;
  final void Function(double) onBlueColorChannelChange;
  final List<BoxShadow> colorTileBoxShadow;
  final AnimationController? animationController;
  const ColorMixer({
    Key? key,
    required this.alphaChannel,
    required this.redChannel,
    required this.greenChanne,
    required this.blueChannel,
    required this.onAlphaChannelChange,
    required this.onRedColorChannelChange,
    required this.onGreenColorChannelChange,
    required this.onBlueColorChannelChange,
    this.colorTileBoxShadow = const [
      const BoxShadow(
        blurRadius: 12.0,
        color: Colors.black12,
        offset: Offset(2, 2),
        spreadRadius: 1.0,
      )
    ],
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        builder: (context, _) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChannelIndicator(
                      alphaChannelValue: alphaChannel,
                      blueChannelValue: blueChannel,
                      greenChannelValue: greenChanne,
                      redChannelValue: redChannel,
                    ),
                    _ChannelSlider(
                      color: Colors.grey[400],
                      colorChannelValue:
                          (animationController!.value * alphaChannel!).round(),
                      onColorChannelValueChange: onAlphaChannelChange,
                      boxShadow: colorTileBoxShadow,
                    ),
                    _ChannelSlider(
                      color: Colors.red,
                      colorChannelValue:
                          (animationController!.value * redChannel!).round(),
                      onColorChannelValueChange: onRedColorChannelChange,
                      boxShadow: colorTileBoxShadow,
                    ),
                    _ChannelSlider(
                      color: Colors.green,
                      colorChannelValue:
                          (animationController!.value * greenChanne!).round(),
                      onColorChannelValueChange: onGreenColorChannelChange,
                      boxShadow: colorTileBoxShadow,
                    ),
                    _ChannelSlider(
                      color: Colors.blue,
                      colorChannelValue:
                          (animationController!.value * blueChannel!).round(),
                      onColorChannelValueChange: onBlueColorChannelChange,
                      boxShadow: colorTileBoxShadow,
                    ),
                  ],
                );
              }));
        });
  }
}

class _ChannelIndicator extends StatelessWidget {
  final int? alphaChannelValue;
  final int? redChannelValue;
  final int? greenChannelValue;
  final int? blueChannelValue;

  const _ChannelIndicator({
    Key? key,
    required this.alphaChannelValue,
    required this.redChannelValue,
    required this.greenChannelValue,
    required this.blueChannelValue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: Container(
          height: 24.0,
          width: 64.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(
              16.0,
            )),
            color: Color.fromARGB(
              alphaChannelValue!,
              redChannelValue!,
              greenChannelValue!,
              blueChannelValue!,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChannelSlider extends StatelessWidget {
  final Color? color;
  final int colorChannelValue;
  final void Function(double) onColorChannelValueChange;
  final List<BoxShadow> boxShadow;
  final EdgeInsets margin;
  const _ChannelSlider({
    Key? key,
    required this.color,
    required this.colorChannelValue,
    required this.onColorChannelValueChange,
    required this.boxShadow,
    this.margin = const EdgeInsets.symmetric(
      vertical: 4.0,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: margin,
        child: Column(
          children: [
            LitSlider(
              min: 0,
              max: 255,
              onChanged: onColorChannelValueChange,
              value: colorChannelValue.toDouble(),
              displayRangeBadges: false,
              displayValue: false,
              activeTrackColor: color,
              thumbColor: Color.lerp(color, Colors.white, 0.40),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                      4.0,
                    )),
                    color: color,
                  ),
                  height: 8.0,
                  width: 8.0,
                ),
              ),
            )
          ],
        ));
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   mainAxisSize: MainAxisSize.max,
    //   children: [
    //     ColorTile(
    //       height: 64.0,
    //       width: 64.0,
    //       boxShadow: boxShadow,
    //       color: Color.lerp(Colors.white, color, colorChannelValue / 255),
    //     ),
    //     LitSlider(
    //       min: 0,
    //       max: 255,
    //       onChanged: onColorChannelValueChange,
    //       value: colorChannelValue.toDouble(),
    //       displayBadges: false,
    //       displayValue: false,
    //       activeTrackColor: color,
    //       thumbColor: Color.lerp(color, Colors.white, 0.40),
    //     ),
    //   ],
    // );
  }
}
