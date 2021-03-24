import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_deletable_container.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:history_of_me/view/widgets/edit_bookmark_screen/color_mixer.dart';
import 'package:history_of_me/view/widgets/edit_bookmark_screen/selectable_color_tile.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class UserCreatedColorCard extends StatefulWidget {
  final int selectedColorValue;
  final void Function(Color) onSelectColorCallback;
  //final List<Color> colors;
  final bool Function(Color) addColor;
  //final void Function() handleColorDuplicate;
  final List<BoxShadow> buttonBoxShadow;
  const UserCreatedColorCard(
      {Key key,
      @required this.selectedColorValue,
      @required this.onSelectColorCallback,
      //this.colors = const [],
      @required this.addColor,
      //@required this.handleColorDuplicate,
      this.buttonBoxShadow = const [
        const BoxShadow(
          blurRadius: 2.0,
          color: Colors.black12,
          offset: Offset(2, 1),
          spreadRadius: 0.5,
        ),
      ]})
      : super(key: key);

  @override
  _UserCreatedColorCardState createState() => _UserCreatedColorCardState();
}

class _UserCreatedColorCardState extends State<UserCreatedColorCard>
    with TickerProviderStateMixin {
  AnimationController _additionalColorsAnimationController;
  AnimationController _colorSliderAnimationController;
  bool showAllColors;
  bool enableColorMix;
  int redChannel;
  int greenChannel;
  int blueChannel;
  int alphaChannel;
  Future<void> animateMixColorTransition() async {
    return enableColorMix
        ? _additionalColorsAnimationController.forward(from: 0.0)
        : _additionalColorsAnimationController.reverse(from: 1.0);
  }

  Future<void> animateAdditionalColorsTransition() async {
    return showAllColors
        ? _additionalColorsAnimationController
            .reverse(from: 1.0)
            .then((value) => _additionalColorsAnimationController.forward())
        : _additionalColorsAnimationController.forward(from: 0.0);
  }

  void toggleAllColors() {
    animateAdditionalColorsTransition().then((value) => setState(() {
          showAllColors = !showAllColors;
        }));
  }

  void toggleEnableColorMix() {
    animateMixColorTransition().then((value) => setState(() {
          enableColorMix = !enableColorMix;
        }));
  }

  void onAlphaChannelChange(double value) {
    setState(() {
      alphaChannel = value.round();
    });
  }

  void onRedColorChannelChange(double value) {
    setState(() {
      redChannel = value.round();
    });
  }

  void onGreenColorChannelChange(double value) {
    setState(() {
      greenChannel = value.round();
    });
  }

  void onBlueColorChannelChange(double value) {
    setState(() {
      blueChannel = value.round();
    });
  }

  bool get colorValuesSet {
    return alphaChannel != 0 ||
        redChannel != 0 ||
        greenChannel != 0 ||
        blueChannel != 0;
  }

  void handleColorMixerPress() {
    if (enableColorMix) {
      colorValuesSet
          ? _addColor(
              Color.fromARGB(
                alphaChannel,
                redChannel,
                greenChannel,
                blueChannel,
              ),
            )
          : toggleEnableColorMix();
    } else {
      toggleEnableColorMix();
    }
  }

  void resetColorChannelValues() {
    _colorSliderAnimationController
        .reverse(from: 1.0)
        .then((_) => setState(() {
              alphaChannel = 0;
              redChannel = 0;
              greenChannel = 0;
              blueChannel = 0;
            }))
        .then((__) => _colorSliderAnimationController.forward());
  }

  void _addColor(Color color) {
    if (widget.addColor(color)) {
      resetColorChannelValues();
      toggleEnableColorMix();
    }
  }

  @override
  void initState() {
    super.initState();

    showAllColors = false;
    enableColorMix = false;
    alphaChannel = 0;
    redChannel = 0;
    greenChannel = 0;
    blueChannel = 0;
    _additionalColorsAnimationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _colorSliderAnimationController = AnimationController(
      duration: Duration(milliseconds: 130),
      vsync: this,
    );

    _additionalColorsAnimationController.forward();
    _colorSliderAnimationController.forward();
  }

  @override
  void dispose() {
    _additionalColorsAnimationController.dispose();
    _colorSliderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HiveDBService().getUserCreatedColors(),
        builder: (BuildContext context, Box<dynamic> colorsBox, Widget _) {
          print("colors box length: ${colorsBox.length}");
          List<dynamic> userColors = colorsBox.values.toList();
          return LitElevatedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Color",
                  style: LitTextStyles.sansSerif.copyWith(
                    color: HexColor('#878787'),
                    fontSize: 22.0,
                  ),
                ),
                !enableColorMix
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: _UserCreatedColorGrid(
                              additionalColorsAnimationController:
                                  _additionalColorsAnimationController,
                              boxShadow: widget.buttonBoxShadow,
                              onSelectColorCallback:
                                  widget.onSelectColorCallback,
                              selectedColorValue: widget.selectedColorValue,
                              showAllColors: showAllColors,
                              userColors: userColors,
                            ),
                          ),
                        ],
                      )
                    : ColorMixer(
                        alphaChannel: alphaChannel,
                        redChannel: redChannel,
                        greenChanne: greenChannel,
                        blueChannel: blueChannel,
                        onAlphaChannelChange: onAlphaChannelChange,
                        onRedColorChannelChange: onRedColorChannelChange,
                        onGreenColorChannelChange: onGreenColorChannelChange,
                        onBlueColorChannelChange: onBlueColorChannelChange,
                        animationController: _colorSliderAnimationController,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !enableColorMix
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                            ),
                            child: LitRoundedElevatedButton(
                              color: LitColors.lightGrey,
                              boxShadow: widget.buttonBoxShadow,
                              child: Text(
                                "Show ${showAllColors ? 'less' : 'more'}",
                                style: LitTextStyles.sansSerif.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: toggleAllColors,
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: LitRoundedElevatedButton(
                              color: LitColors.midRed,
                              boxShadow: widget.buttonBoxShadow,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8.0,
                                ),
                                child: Icon(
                                  LitIcons.times,
                                  color: Colors.white,
                                  size: 14.0,
                                ),
                              ),
                              onPressed: resetColorChannelValues,
                            ),
                          ),
                    showAllColors
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: LitRoundedElevatedButton(
                              color: LitColors.lightPink,
                              boxShadow: widget.buttonBoxShadow,
                              child: enableColorMix
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                        horizontal: 8.0,
                                      ),
                                      child: colorValuesSet
                                          ? Icon(
                                              LitIcons.check,
                                              color: LitColors.mediumOliveGreen,
                                              size: 14.0,
                                            )
                                          : Icon(
                                              LitIcons.chevron_left_solid,
                                              color: Colors.white,
                                              size: 14.0,
                                            ),
                                    )
                                  : Text(
                                      "Create Color",
                                      style: LitTextStyles.sansSerif.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                              onPressed: handleColorMixerPress,
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class _UserCreatedColorGrid extends StatefulWidget {
  final AnimationController additionalColorsAnimationController;
  final List<BoxShadow> boxShadow;
  final bool showAllColors;
  final List<dynamic> userColors;
  final void Function(Color) onSelectColorCallback;
  final int selectedColorValue;
  const _UserCreatedColorGrid({
    Key key,
    @required this.additionalColorsAnimationController,
    @required this.boxShadow,
    @required this.showAllColors,
    @required this.userColors,
    @required this.onSelectColorCallback,
    @required this.selectedColorValue,
  }) : super(key: key);
  @override
  __UserCreatedColorGridState createState() => __UserCreatedColorGridState();
}

class __UserCreatedColorGridState extends State<_UserCreatedColorGrid>
    with TickerProviderStateMixin {
  bool _deletionEnabled;

  AnimationController _animationController;

  void _toggleDeletionEnabled() {
    setState(() {
      _deletionEnabled = !_deletionEnabled;
    });
    if (_deletionEnabled) {
      _animationController.repeat(reverse: true);
    } else {
      if (_animationController.isAnimating) {
        _animationController.stop();
        _animationController.animateTo(1.0);
      }
    }
    print("toggled deletion with new state $_deletionEnabled");
  }

  @override
  void initState() {
    super.initState();
    _deletionEnabled = false;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: widget.additionalColorsAnimationController,
          builder: (context, _) {
            List<Widget> columnChildren = [];
            const int columns = 5;
            int colorIndex = 0;
            for (int i = 0;
                widget.showAllColors
                    ? (i < (widget.userColors.length / columns).ceil())
                    : (i < (1));
                i++) {
              List<Widget> colorRow = [];

              for (int j = 0; j < 5; j++) {
                if (colorIndex < (widget.userColors.length)) {
                  colorRow.add(
                    AnimatedOpacity(
                      duration:
                          widget.additionalColorsAnimationController.duration,
                      opacity: widget.additionalColorsAnimationController.value,
                      child: _DeletableColorGridItem(
                        animation: _animationController,
                        boxShadow: widget.boxShadow,
                        columns: columns,
                        constraints: constraints,
                        deletionEnabled: _deletionEnabled,
                        index: colorIndex,
                        onSelectColorCallback: widget.onSelectColorCallback,
                        selectedColorValue: widget.selectedColorValue,
                        toggleDeletionEnabled: _toggleDeletionEnabled,
                        userColors: widget.userColors,
                      ),
                    ),
                  );
                  colorIndex++;
                }
              }
              columnChildren.add(Row(
                children: colorRow,
              ));
            }
            return Column(
              children: columnChildren,
            );
          },
        );
      },
    );
  }
}

class _DeletableColorGridItem extends StatefulWidget {
  final bool deletionEnabled;
  final Animation animation;
  final List<BoxShadow> boxShadow;
  final int index;
  final List<dynamic> userColors;
  final int selectedColorValue;
  final void Function(Color) onSelectColorCallback;
  final BoxConstraints constraints;
  final int columns;
  final void Function() toggleDeletionEnabled;
  const _DeletableColorGridItem({
    Key key,
    @required this.deletionEnabled,
    @required this.animation,
    @required this.boxShadow,
    @required this.index,
    @required this.userColors,
    @required this.selectedColorValue,
    @required this.onSelectColorCallback,
    @required this.constraints,
    @required this.columns,
    @required this.toggleDeletionEnabled,
  }) : super(key: key);
  @override
  _DeletableColorGridItemState createState() => _DeletableColorGridItemState();
}

class _DeletableColorGridItemState extends State<_DeletableColorGridItem> {
  Color _mapColor(UserCreatedColor userColor) {
    int red = userColor.red;
    int green = userColor.green;
    int blue = userColor.blue;
    int alpha = userColor.alpha;
    return Color.fromARGB(alpha, red, green, blue);
  }

  void _onDelete() {
    HiveDBService().deleteUserCreatedColor(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return LitDeletableContainer(
      deletionEnabled: widget.deletionEnabled,
      animation: widget.animation,
      child: SelectableColorTile(
        boxShadow: widget.boxShadow,
        onSelectCallback: widget.onSelectColorCallback,
        selected: widget.selectedColorValue ==
            _mapColor(
              widget.userColors[widget.index],
            ).value,
        color: _mapColor(
          widget.userColors[widget.index],
        ),
        height: widget.constraints.maxWidth / widget.columns,
        width: widget.constraints.maxWidth / widget.columns,
      ),
      toggleDeletionEnabled: widget.toggleDeletionEnabled,
      colorIndex: widget.index,
      onDelete: _onDelete,
    );
  }
}
