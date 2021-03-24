import 'package:flutter/material.dart';
import 'package:history_of_me/controller/backdrop_photo_finder.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class BackdropPhotoOverlay extends StatefulWidget {
  final ScrollController scrollController;
  final void Function() showChangePhotoDialogCallback;
  final List<BackdropPhoto> backdropPhotos;
  final bool loading;
  //final int selectedPhotoIndex;
  final DiaryEntry diaryEntry;
  const BackdropPhotoOverlay({
    Key key,
    @required this.scrollController,
    @required this.showChangePhotoDialogCallback,
    @required this.backdropPhotos,
    @required this.loading,
    //@required this.selectedPhotoIndex,
    @required this.diaryEntry,
  }) : super(key: key);

  @override
  _BackdropPhotoOverlayState createState() => _BackdropPhotoOverlayState();
}

class _BackdropPhotoOverlayState extends State<BackdropPhotoOverlay>
    with TickerProviderStateMixin {
  AnimationOnScrollController _animationOnScrollController;

  @override
  void initState() {
    super.initState();
    _animationOnScrollController = AnimationOnScrollController(
      scrollController: widget.scrollController,
      requiredScrollOffset: 16.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationOnScrollController.dispose();
    super.dispose();
  }

  AnimationController get _onScrollAnimation {
    return _animationOnScrollController.animationController;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _onScrollAnimation,
        builder: (BuildContext context, Widget _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform(
                transform: Matrix4.translationValues(
                    -(_onScrollAnimation.value *
                        MediaQuery.of(context).size.width),
                    0,
                    0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: LitBackButton(
                    backgroundColor: LitColors.mediumGrey.withOpacity(0.5),
                    iconColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 80.0,
                  left: 30.0,
                  right: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ChangePhotoButton(
                      onScrollAnimationController:
                          _animationOnScrollController.animationController,
                      onPressed: widget.showChangePhotoDialogCallback,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            (_animationOnScrollController
                                    .animationController.value *
                                MediaQuery.of(context).size.width),
                            0,
                            0),
                        child: widget.loading
                            ? SizedBox()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _IconLabel(
                                    text: BackdropPhotoFinder(
                                      widget.backdropPhotos,
                                      widget.diaryEntry,
                                    ).findBackdropPhotoLocation(),
                                    iconData: LitIcons.map_marker,
                                    color: Colors.white,
                                    backgroundColor:
                                        HexColor('#d1cdcd').withOpacity(0.33),
                                  ),
                                  _IconLabel(
                                    text: BackdropPhotoFinder(
                                      widget.backdropPhotos,
                                      widget.diaryEntry,
                                    ).findBackdropPhotoPhotographer(),
                                    iconData: LitIcons.person_solid,
                                    color: Colors.white,
                                    backgroundColor:
                                        HexColor('#d1cdcd').withOpacity(0.33),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _ChangePhotoButton extends StatelessWidget {
  final AnimationController onScrollAnimationController;
  final double dxTransform;
  final void Function() onPressed;
  const _ChangePhotoButton({
    Key key,
    @required this.onScrollAnimationController,
    this.dxTransform = 100.0,
    @required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Transform(
        transform: Matrix4.translationValues(
            -(onScrollAnimationController.value * dxTransform), 0, 0),
        child: LitPushedButton(
          onPressed: onPressed,
          child: BluredBackgroundContainer(
            borderRadius: BorderRadius.all(
              Radius.circular(
                15.0,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    15.0,
                  ),
                ),
                color: Colors.white24,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 18.0,
                ),
                child: Icon(
                  LitIcons.photos,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ),
            blurRadius: 4.0,
          ),
        ),
      ),
    );
  }
}

class _IconLabel extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;
  final Color backgroundColor;
  final EdgeInsets padding;
  const _IconLabel({
    Key key,
    @required this.text,
    @required this.iconData,
    @required this.color,
    @required this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: Icon(
                    iconData,
                    color: color,
                    size: 13.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: Text(
                    text,
                    style: LitTextStyles.sansSerif.copyWith(
                      color: color,
                      fontSize: 12.0,
                      letterSpacing: 0.40,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
