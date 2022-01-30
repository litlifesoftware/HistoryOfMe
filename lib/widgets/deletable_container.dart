part of widgets;

class DeletableContainer extends StatefulWidget {
  final Widget child;
  final void Function() toggleDeletionEnabled;
  final bool? deletionEnabled;
  final Animation? animation;
  final int colorIndex;
  final void Function() onDelete;
  const DeletableContainer({
    Key? key,
    required this.deletionEnabled,
    required this.animation,
    required this.child,
    required this.toggleDeletionEnabled,
    required this.colorIndex,
    required this.onDelete,
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

  double get degree {
    return (2 * pi / 360);
  }

  bool get isAnimating {
    return widget.animation!.status == AnimationStatus.forward ||
        widget.animation!.status == AnimationStatus.reverse;
  }

  Matrix4 get translation {
    double rand1 = Random().nextDouble();
    double rand2 = Random().nextDouble();
    double start = 1.0;
    double end = -(start);
    double animation = widget.animation!.value;
    return Matrix4.translationValues(
      (start * rand1) + (((end * rand2 * 0.25)) * (animation * 0.75)),
      (start * rand1) + (((end * rand2 * 0.25)) * (animation * 0.75)),
      0,
    );
  }

  double get rotationRad {
    return (-2.5 * degree) + (5 * degree * (widget.animation!.value));
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
      animation: widget.animation!,
      builder: (context, _) {
        return InkWell(
          onLongPress: _onToggleDeletionEnabled,
          child: Transform.rotate(
            angle: isAnimating ? rotationRad : 0,
            child: Transform(
              transform: isAnimating
                  ? translation
                  : Matrix4.translationValues(0, 0, 0),
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
                      widget.deletionEnabled!
                          ? Transform.scale(
                              scale: 1.0 - _deletedAnimation.value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 2.0,
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: _onDelete,
                                    child: Container(
                                      height: 26.0,
                                      width: 38.0,
                                      decoration: BoxDecoration(
                                        color: LitColors.lightRed,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            12.0,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          LitIcons.times,
                                          color: Colors.white,
                                          size: 8.0,
                                        ),
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
          ),
        );
      },
    );
  }
}
