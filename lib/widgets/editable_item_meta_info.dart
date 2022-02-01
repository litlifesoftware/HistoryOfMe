part of widgets;

class EditableItemMetaInfo extends StatefulWidget {
  final int? lastUpdateTimestamp;
  final bool showUnsavedBadge;

  const EditableItemMetaInfo({
    Key? key,
    required this.lastUpdateTimestamp,
    required this.showUnsavedBadge,
  }) : super(key: key);

  @override
  _EditableItemMetaInfoState createState() => _EditableItemMetaInfoState();
}

class _EditableItemMetaInfoState extends State<EditableItemMetaInfo>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(
        milliseconds: 3000,
      ),
      vsync: this,
    );
    _animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.showUnsavedBadge
            ? _AnimatedUnchangedBadge(
                animation: _animationController,
              )
            : SizedBox(),
        AnimatedUpdatedLabel(
          lastUpdateTimestamp: widget.lastUpdateTimestamp,
        ),
      ],
    );
  }
}

class _AnimatedUnchangedBadge extends StatelessWidget {
  final Animation? animation;

  const _AnimatedUnchangedBadge({
    Key? key,
    required this.animation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 86.0,
      ),
      child: AnimatedBuilder(
        animation: animation!,
        builder: (context, _) {
          return LitTextBadge(
            backgroundColor: Color.lerp(LitColors.mediumGrey, Colors.white,
                    0.8 * animation!.value) ??
                LitColors.mediumGrey,
            label: LeitmotifLocalizations.of(context).unsavedLabel.capitalize(),
            textColor: Color.lerp(
                  Colors.white,
                  LitColors.mediumGrey,
                  0.1 + (animation!.value * 0.9),
                ) ??
                Colors.white,
          );
        },
      ),
    );
  }
}
