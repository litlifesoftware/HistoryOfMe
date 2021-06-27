import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'deletable_container.dart';
import 'selectable_color_tile.dart';

class PrimaryColorSelectorCard extends StatefulWidget {
  final String cardTitle;
  final int? selectedColorValue;
  final void Function(Color) onSelectPrimaryColor;
  //final List<Color> colors;
  //final void Function(Color) addColor;
  final void Function() onAddColorError;
  //final void Function() handleColorDuplicate;
  final List<BoxShadow> buttonBoxShadow;
  final List<UserCreatedColor> userCreatedColors;
  const PrimaryColorSelectorCard({
    Key? key,
    required this.cardTitle,
    required this.selectedColorValue,
    required this.onSelectPrimaryColor,
    //this.colors = const [],
    //@required this.addColor,
    required this.onAddColorError,
    //@required this.handleColorDuplicate,
    this.buttonBoxShadow = const [
      const BoxShadow(
        blurRadius: 2.0,
        color: Colors.black12,
        offset: Offset(2, 1),
        spreadRadius: 0.5,
      ),
    ],
    required this.userCreatedColors,
  }) : super(key: key);

  @override
  _PrimaryColorSelectorCardState createState() =>
      _PrimaryColorSelectorCardState();
}

class _PrimaryColorSelectorCardState extends State<PrimaryColorSelectorCard>
    with TickerProviderStateMixin {
  AnimationController? _additionalColorsAnimationController;
  AnimationController? _colorSliderAnimationController;
  bool showAllColors = false;
  bool enableColorMix = false;
  int redChannel = 0;
  int greenChannel = 0;
  int blueChannel = 0;
  int alphaChannel = 0;
  Future<void> animateMixColorTransition() async {
    return enableColorMix
        ? _additionalColorsAnimationController!.forward(from: 0.0)
        : _additionalColorsAnimationController!.reverse(from: 1.0);
  }

  Future<void> animateAdditionalColorsTransition() async {
    return showAllColors
        ? _additionalColorsAnimationController!
            .reverse(from: 1.0)
            .then((value) => _additionalColorsAnimationController!.forward())
        : _additionalColorsAnimationController!.forward(from: 0.0);
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
    return Color.fromARGB(
            alphaChannel, redChannel, greenChannel, blueChannel) !=
        Color.fromARGB(0, 0, 0, 0);
    // return alphaChannel != 0 ||
    //     redChannel != 0 ||
    //     greenChannel != 0 ||
    //     blueChannel != 0;
  }

  // void handleColorMixerPress() {
  //   if (enableColorMix) {
  //     colorValuesSet
  //         ? _addColor(
  //             Color.fromARGB(
  //               alphaChannel,
  //               redChannel,
  //               greenChannel,
  //               blueChannel,
  //             ),
  //           )
  //         : toggleEnableColorMix();
  //   } else {
  //     toggleEnableColorMix();
  //   }
  // }
  void handleOnCreateColorPress() {
    showDialog(
      context: context,
      builder: (_) => LitColorPickerDialog(
        onApplyColor: (Color color) {
          _addColor(color);
        },
        initialColor: Color(widget.selectedColorValue!),
        applyLabel: "Apply",
        resetLabel: "Reset",
        titleText: "Pick a color",
        transparentColorText: "Color is fully transparent",
      ),
    );
  }

  void resetColorChannelValues() {
    _colorSliderAnimationController!
        .reverse(from: 1.0)
        .then((_) => setState(() {
              alphaChannel = 0;
              redChannel = 0;
              greenChannel = 0;
              blueChannel = 0;
            }))
        .then((__) => _colorSliderAnimationController!.forward());
  }

  void _addColor(Color color) {
    try {
      HiveDBService(debug: DEBUG).addUserCreatedColor(
        color.alpha,
        color.red,
        color.green,
        color.blue,
      );
      resetColorChannelValues();
      // toggleEnableColorMix();
      animateMixColorTransition();
      animateAdditionalColorsTransition();
    } catch (e) {
      widget.onAddColorError();
    }
  }

  @override
  void initState() {
    super.initState();

    _additionalColorsAnimationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _colorSliderAnimationController = AnimationController(
      duration: Duration(milliseconds: 130),
      vsync: this,
    );

    _additionalColorsAnimationController!.forward();
    _colorSliderAnimationController!.forward();
  }

  @override
  void dispose() {
    _additionalColorsAnimationController!.dispose();
    _colorSliderAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LitElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.cardTitle,
            style: LitTextStyles.sansSerif.copyWith(
              color: HexColor('#878787'),
              fontSize: 22.0,
            ),
          ),
          // !enableColorMix
          //     ? Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.symmetric(
          //               vertical: 8.0,
          //             ),
          //             child: UserCreatedColorGrid(
          //               additionalColorsAnimationController:
          //                   _additionalColorsAnimationController,
          //               boxShadow: widget.buttonBoxShadow,
          //               onSelectColorCallback: widget.onSelectPrimaryColor,
          //               selectedColorValue: widget.selectedColorValue,
          //               showAllColors: showAllColors,
          //               userColors: widget.userCreatedColors,
          //             ),
          //           ),
          //         ],
          //       )
          //     : ColorMixer(
          //         alphaChannel: alphaChannel,
          //         redChannel: redChannel,
          //         greenChanne: greenChannel,
          //         blueChannel: blueChannel,
          //         onAlphaChannelChange: onAlphaChannelChange,
          //         onRedColorChannelChange: onRedColorChannelChange,
          //         onGreenColorChannelChange: onGreenColorChannelChange,
          //         onBlueColorChannelChange: onBlueColorChannelChange,
          //         animationController: _colorSliderAnimationController,
          //       ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: UserCreatedColorGrid(
                  additionalColorsAnimationController:
                      _additionalColorsAnimationController,
                  boxShadow: widget.buttonBoxShadow,
                  onSelectColorCallback: widget.onSelectPrimaryColor,
                  selectedColorValue: widget.selectedColorValue,
                  showAllColors: showAllColors,
                  userColors: widget.userCreatedColors,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !enableColorMix
                  ? LitRoundedElevatedButton(
                      color: LitColors.lightGrey,
                      boxShadow: widget.buttonBoxShadow,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        showAllColors
                            ? HOMLocalizations(context).less.toUpperCase()
                            : HOMLocalizations(context).more.toUpperCase(),
                        style: LitSansSerifStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: toggleAllColors,
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: colorValuesSet
                          ? LitRoundedElevatedButton(
                              color: LitColors.midRed,
                              boxShadow: widget.buttonBoxShadow,
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 12.0,
                              ),
                              child: Text(
                                HOMLocalizations(context).reset.toUpperCase(),
                                style: LitSansSerifStyles.button.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: resetColorChannelValues,
                            )
                          : SizedBox(),
                    ),
              showAllColors
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: LitRoundedElevatedButton(
                        color: LitColors.lightPink,
                        boxShadow: widget.buttonBoxShadow,
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 12.0,
                        ),
                        child: enableColorMix
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 2.0,
                                ),
                                child: colorValuesSet
                                    ? Icon(
                                        LitIcons.check,
                                        color: LitColors.mediumOliveGreen,
                                        size: 15.0,
                                      )
                                    : Icon(
                                        LitIcons.chevron_left_solid,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                              )
                            : Text(
                                HOMLocalizations(context).create.toUpperCase(),
                                style: LitSansSerifStyles.button.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                        onPressed: handleOnCreateColorPress,
                      ),
                    )
                  : SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}

class UserCreatedColorGrid extends StatefulWidget {
  final AnimationController? additionalColorsAnimationController;
  final List<BoxShadow> boxShadow;
  final bool? showAllColors;
  final List<UserCreatedColor> userColors;
  final void Function(Color) onSelectColorCallback;
  final int? selectedColorValue;
  const UserCreatedColorGrid({
    Key? key,
    required this.additionalColorsAnimationController,
    required this.boxShadow,
    required this.showAllColors,
    required this.userColors,
    required this.onSelectColorCallback,
    required this.selectedColorValue,
  }) : super(key: key);
  @override
  _UserCreatedColorGridState createState() => _UserCreatedColorGridState();
}

class _UserCreatedColorGridState extends State<UserCreatedColorGrid>
    with TickerProviderStateMixin {
  bool? _deletionEnabled;

  AnimationController? _animationController;

  void _toggleDeletionEnabled() {
    setState(() {
      _deletionEnabled = !_deletionEnabled!;
    });
    if (_deletionEnabled!) {
      _animationController!.repeat(reverse: true);
    } else {
      if (_animationController!.isAnimating) {
        _animationController!.stop();
        _animationController!.animateTo(1.0);
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
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: widget.additionalColorsAnimationController!,
          builder: (context, _) {
            List<Widget> columnChildren = [];
            const int columns = 5;
            int colorIndex = 0;
            for (int i = 0;
                widget.showAllColors!
                    ? (i < (widget.userColors.length / columns).ceil())
                    : (i < (1));
                i++) {
              List<Widget> colorRow = [];

              for (int j = 0; j < 5; j++) {
                if (colorIndex < (widget.userColors.length)) {
                  colorRow.add(
                    AnimatedOpacity(
                      duration:
                          widget.additionalColorsAnimationController!.duration!,
                      opacity:
                          widget.additionalColorsAnimationController!.value,
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
  final bool? deletionEnabled;
  final Animation? animation;
  final List<BoxShadow> boxShadow;
  final int index;
  final List<dynamic> userColors;
  final int? selectedColorValue;
  final void Function(Color) onSelectColorCallback;
  final BoxConstraints constraints;
  final int columns;
  final void Function() toggleDeletionEnabled;
  const _DeletableColorGridItem({
    Key? key,
    required this.deletionEnabled,
    required this.animation,
    required this.boxShadow,
    required this.index,
    required this.userColors,
    required this.selectedColorValue,
    required this.onSelectColorCallback,
    required this.constraints,
    required this.columns,
    required this.toggleDeletionEnabled,
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
    return DeletableContainer(
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
