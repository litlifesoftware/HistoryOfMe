part of widgets;

class EllipseIcon extends StatefulWidget {
  final bool animated;
  final Axis axis;
  final double dotHeight;
  final double dotWidth;
  final Color dotColor;
  final List<BoxShadow> boxShadow;

  const EllipseIcon(
      {Key? key,
      this.animated = true,
      this.axis = Axis.horizontal,
      this.dotHeight = 8.0,
      this.dotWidth = 8.0,
      this.dotColor = LitColors.mediumGrey,
      this.boxShadow = const [
        BoxShadow(
          blurRadius: 3.0,
          color: Colors.black12,
          offset: Offset(
            1.0,
            1.0,
          ),
          spreadRadius: 1.0,
        )
      ]})
      : super(key: key);

  @override
  _EllipsisIconState createState() => _EllipsisIconState();
}

class _EllipsisIconState extends State<EllipseIcon>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(
        milliseconds: 590,
      ),
      vsync: this,
    );
    if (widget.animated) {
      _animationController!.forward();
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, _) {
        final List<Widget> children = [];
        for (int i = 0; i < 3; i++) {
          children.add(
            _Dot(
              animated: widget.animated,
              axis: widget.axis,
              animationController: _animationController,
              height: widget.dotHeight,
              width: widget.dotWidth,
              color: widget.dotColor,
              boxShadow: widget.boxShadow,
            ),
          );
        }
        return widget.axis == Axis.horizontal
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  final AnimationController? animationController;
  final bool animated;
  final double height;
  final double width;
  final Color color;
  final List<BoxShadow> boxShadow;
  final Axis axis;
  const _Dot({
    Key? key,
    required this.animationController,
    required this.animated,
    required this.height,
    required this.width,
    required this.color,
    required this.boxShadow,
    required this.axis,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: animated
          ? Matrix4.translationValues(
              -8.0 + 8.0 * (animationController!.value),
              0,
              0,
            )
          : Matrix4.translationValues(
              0,
              0,
              0,
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2.0,
          vertical: 1.0,
        ),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
            boxShadow: boxShadow,
          ),
        ),
      ),
    );
  }
}
