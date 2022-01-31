part of widgets;

class BackdropPhotoOverlay extends StatefulWidget {
  final ScrollController? scrollController;
  final void Function() showChangePhotoDialogCallback;
  final List<BackdropPhoto> backdropPhotos;
  final bool? loading;
  //final int selectedPhotoIndex;
  final DiaryEntry diaryEntry;

  const BackdropPhotoOverlay({
    Key? key,
    required this.scrollController,
    required this.showChangePhotoDialogCallback,
    required this.backdropPhotos,
    required this.loading,
    //@required this.selectedPhotoIndex,
    required this.diaryEntry,
  }) : super(key: key);

  @override
  _BackdropPhotoOverlayState createState() => _BackdropPhotoOverlayState();
}

class _BackdropPhotoOverlayState extends State<BackdropPhotoOverlay>
    with TickerProviderStateMixin {
  late AnimationOnScrollController _animationOnScrollController;
  late BackdropPhotoController _backdropController;

  void _navigateDetailScreen() {
    BackdropPhoto backdropPhoto = BackdropPhotoController(
      widget.backdropPhotos,
      widget.diaryEntry,
    ).findBackdropPhoto();
    HOMNavigator(context)
        .toBackdropPhotoDetailScreen(backdropPhoto: backdropPhoto);
  }

  @override
  void initState() {
    super.initState();
    _animationOnScrollController = AnimationOnScrollController(
      scrollController: widget.scrollController,
      requiredScrollOffset: 16.0,
      vsync: this,
    );
    _backdropController = BackdropPhotoController(
      widget.backdropPhotos,
      widget.diaryEntry,
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

  /// Returns the screen width.
  double get _screenWidth => MediaQuery.of(context).size.width;

  /// Returns an animated transform matrix.
  Matrix4 get _transform => Matrix4.translationValues(
        -(_onScrollAnimation.value * _screenWidth),
        0,
        0,
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _onScrollAnimation,
        builder: (BuildContext context, Widget? _) {
          return Container(
            height: EntryDetailBackdrop.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Transform(
                  transform: _transform,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      child: LitBackButton(
                        backgroundColor: LitColors.mediumGrey.withOpacity(0.5),
                        iconColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _ChangePhotoButton(
                          onScrollAnimationController:
                              _animationOnScrollController.animationController,
                          onPressed: widget.showChangePhotoDialogCallback,
                        ),
                        widget.loading!
                            ? SizedBox()
                            : _PhotoDetailsButton(
                                animationController:
                                    _animationOnScrollController
                                        .animationController,
                                onPressed: _navigateDetailScreen,
                                location: _backdropController
                                    .findBackdropPhotoLocation()!,
                                photographerName: BackdropPhotoController(
                                  widget.backdropPhotos,
                                  widget.diaryEntry,
                                ).findBackdropPhotoPhotographer()!,
                                offsetY: MediaQuery.of(context).size.width,
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PhotoDetailsButton extends StatelessWidget {
  final AnimationController animationController;
  final void Function() onPressed;
  final String location;
  final String photographerName;
  final double offsetY;
  const _PhotoDetailsButton({
    Key? key,
    required this.animationController,
    required this.onPressed,
    required this.location,
    required this.photographerName,
    required this.offsetY,
  }) : super(key: key);

  /// Returns an animated transform matrix.
  Matrix4 get _transform => Matrix4.translationValues(
        (animationController.value * offsetY),
        0,
        0,
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Transform(
        transform: _transform,
        child: LitPushedButton(
          onPressed: onPressed,
          child: BluredBackgroundContainer(
            blurRadius: 2.0,
            borderRadius: BorderRadius.all(
              Radius.circular(
                12.0,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    12.0,
                  ),
                ),
                color: Colors.white24,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IconLabel(
                      text: location,
                      iconData: LitIcons.map_marker,
                      color: Colors.white,
                    ),
                    _IconLabel(
                      text: photographerName,
                      iconData: LitIcons.person_solid,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePhotoButton extends StatelessWidget {
  final AnimationController onScrollAnimationController;
  final double dxTransform;
  final void Function() onPressed;
  const _ChangePhotoButton({
    Key? key,
    required this.onScrollAnimationController,
    this.dxTransform = 100.0,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Transform(
        transform: Matrix4.translationValues(
          -(onScrollAnimationController.value * dxTransform),
          0,
          0,
        ),
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
  final String? text;
  final IconData iconData;
  final Color color;
  final EdgeInsets padding;
  const _IconLabel({
    Key? key,
    required this.text,
    required this.iconData,
    required this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              size: 12.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: Text(
              text!,
              style: LitSansSerifStyles.overline.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
