part of widgets;

class DeletableContainer extends StatefulWidget {
  final Widget child;
  final void Function() toggleDeletionEnabled;
  final bool deletionEnabled;
  final Animation animation;
  final int colorIndex;
  final void Function() onDelete;
  final int? index;
  final int? totalItems;
  const DeletableContainer({
    Key? key,
    required this.deletionEnabled,
    required this.animation,
    required this.child,
    required this.toggleDeletionEnabled,
    required this.colorIndex,
    required this.onDelete,
    this.index,
    this.totalItems,
  }) : super(key: key);

  @override
  _DeletableContainerState createState() => _DeletableContainerState();
}

class _DeletableContainerState extends State<DeletableContainer>
    with TickerProviderStateMixin {
  late AnimationController _deletedAnimation;

  void _onDelete() {
    _deletedAnimation
        .forward()
        .then(
          (_) => widget.onDelete(),
        )
        .then(
          (__) => _deletedAnimation.reverse(),
        );
  }

  void _onToggleDeletionEnabled() {
    widget.toggleDeletionEnabled();
  }

  bool get isAnimating {
    return widget.animation.status == AnimationStatus.forward ||
        widget.animation.status == AnimationStatus.reverse;
  }

  double get rotationRad {
    int i = widget.index ?? 1;

    if (widget.deletionEnabled)
      return (i % 2 == 1
          ? (0.1 * widget.animation.value)
          : (-0.1 * widget.animation.value));

    return 0;
  }

  @override
  void dispose() {
    _deletedAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _deletedAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 230,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, _) {
        return InkWell(
          onLongPress: _onToggleDeletionEnabled,
          child: Transform.rotate(
            angle: isAnimating ? rotationRad : 0,
            child: AnimatedBuilder(
              animation: _deletedAnimation,
              builder: (context, __) {
                return Stack(
                  //alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.0 - (_deletedAnimation.value * 0.2),
                      child: widget.child,
                    ),
                    //widget.child,
                    widget.deletionEnabled
                        ? Transform.scale(
                            scale: 1.0 - _deletedAnimation.value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 2.0,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: LitPushedThroughButton(
                                  backgroundColor: LitColors.lightRed,
                                  accentColor: LitColors.lightRed,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      12.0,
                                    ),
                                  ),
                                  onPressed: _onDelete,
                                  child: Center(
                                    child: Icon(
                                      LitIcons.times,
                                      color: Colors.white,
                                      size: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
