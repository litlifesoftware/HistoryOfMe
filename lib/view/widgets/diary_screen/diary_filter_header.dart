import 'package:flutter/material.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_slider_toggle_button.dart';
import 'package:history_of_me/view/widgets/diary_screen/diary_filter_header_delegate.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class DiaryFilterHeader extends StatefulWidget {
  final int filteredLength;
  final TextStyle textStyle;
  final TextStyle accentTextStyle;
  final bool showFavoritesOnly;
  final void Function() toggleShowFavoritesOnly;
  final double landscapeWidthFactor;
  const DiaryFilterHeader({
    Key key,
    @required this.filteredLength,
    @required this.textStyle,
    @required this.accentTextStyle,
    @required this.showFavoritesOnly,
    @required this.toggleShowFavoritesOnly,
    this.landscapeWidthFactor = 0.75,
  }) : super(key: key);

  @override
  _DiaryFilterHeaderState createState() => _DiaryFilterHeaderState();
}

class _DiaryFilterHeaderState extends State<DiaryFilterHeader>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  double get portraitWidth {
    return MediaQuery.of(context).size.width * 0.75;
  }

  double get landscapeWidth {
    return portraitWidth * widget.landscapeWidthFactor;
  }

  void _onShowFavoritesOnlyToggle() {
    _animationController
        .reverse()
        .then((val) => _animationController.forward());
    widget.toggleShowFavoritesOnly();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(
        milliseconds: 150,
      ),
      vsync: this,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: DiaryFilterHeaderDelegate(
        Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            // BoxShadow(
            //   blurRadius: 16.0,
            //   color: Colors.grey.withOpacity(0.2),
            //   offset: const Offset(0, -2),
            //   spreadRadius: 2.0,
            // )
          ]),
          child: SizedBox(
            width: alternativeWidth(MediaQuery.of(context).size,
                portraitWidth: portraitWidth, landscapeWidth: landscapeWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, _) {
                      return AnimatedOpacity(
                        duration: _animationController.duration,
                        opacity: _animationController.value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 8.0,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: RichText(
                              text: TextSpan(
                                style: widget.textStyle,
                                children: [
                                  TextSpan(text: "${widget.filteredLength} "),
                                  widget.showFavoritesOnly
                                      ? TextSpan(
                                          text: " favorite ",
                                          style: widget.accentTextStyle)
                                      : TextSpan(),
                                  TextSpan(
                                      text: "Entries",
                                      style: widget.accentTextStyle),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: SizedBox(
                    width: 100.0,
                    child: LitSliderToggleButton(
                      onPressed: _onShowFavoritesOnlyToggle,
                      enabledTitle: Icon(
                        LitIcons.heart_solid,
                        size: 16.0,
                        color: widget.showFavoritesOnly
                            ? widget.accentTextStyle.color
                            : widget.textStyle.color,
                      ),
                      disabledTitle: Text(
                        "all",
                        style: widget.textStyle.copyWith(
                          color: widget.showFavoritesOnly
                              ? widget.textStyle.color
                              : widget.accentTextStyle.color,
                        ),
                      ),
                      enabled: widget.showFavoritesOnly,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
