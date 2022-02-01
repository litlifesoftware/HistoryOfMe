part of widgets;

// TODO: Move to Leitmotif.
class LitToggleButtonGroup extends StatefulWidget {
  final int? selectedValue;
  final void Function(int) onSelectCallback;
  final Axis direction;
  final List<LitToggleButtonGroupItemData> items;
  final bool showDividersOnVerticalAxis;
  final EdgeInsets padding;
  final EdgeInsets margin;
  const LitToggleButtonGroup(
      {Key? key,
      required this.selectedValue,
      required this.onSelectCallback,
      this.direction = Axis.horizontal,
      this.showDividersOnVerticalAxis = false,
      required this.items,
      this.margin = const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      this.padding = const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      )})
      : super(key: key);

  @override
  _LitToggleButtonGroupState createState() => _LitToggleButtonGroupState();
}

class _LitToggleButtonGroupState extends State<LitToggleButtonGroup>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  void _onPressed(int index) {
    widget.onSelectCallback(index);
    if (!(widget.selectedValue == index)) {
      _animationController!.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 170), vsync: this);
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: HexColor(
            '#efeded',
          ),
        ),
        child: Padding(
          padding: widget.margin,
          child: Builder(
            builder: (context) {
              final List<Widget> children = [];
              for (int i = 0; i < widget.items.length; i++) {
                children.add(Column(
                  children: [
                    _LitToggleButtonGroupItem(
                      label: widget.items[i].label,
                      value: widget.items[i].value,
                      selected: widget.selectedValue == widget.items[i].value,
                      onSelectCallback: _onPressed,
                      animationController: _animationController,
                    ),
                    Builder(builder: (context) {
                      if ((i < widget.items.length - 1) &&
                          widget.showDividersOnVerticalAxis &&
                          widget.direction == Axis.vertical) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          child: Container(
                            height: 3.0,
                            width: 160.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: HexColor('#8e8e8e').withOpacity(0.5),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    })
                  ],
                ));
              }

              return widget.direction == Axis.horizontal
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    );
            },
          ),
        ),
      ),
    );
  }
}

class LitToggleButtonGroupItemData {
  final String label;
  final int value;

  const LitToggleButtonGroupItemData({
    required this.label,
    required this.value,
  });
}

class _LitToggleButtonGroupItem extends StatelessWidget {
  final String label;
  final int value;
  final bool selected;
  final void Function(int) onSelectCallback;
  final AnimationController? animationController;
  const _LitToggleButtonGroupItem({
    Key? key,
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelectCallback,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(animationController!.value);
    return AnimatedBuilder(
        animation: animationController!,
        builder: (context, _) {
          return InkWell(
            onTap: () => onSelectCallback(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.lerp(
                      selected ? Colors.transparent : HexColor('#8e8e8e'),
                      selected ? HexColor('#8e8e8e') : Colors.transparent,
                      animationController!.value),
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 16.0,
                  ),
                  child: Transform.scale(
                    scale: 0.86 + (animationController!.value * 0.14),
                    child: Text(
                      label,
                      style: LitTextStyles.sansSerif.copyWith(
                        color: Color.lerp(
                            selected ? HexColor('#8e8e8e') : Colors.white,
                            selected ? Colors.white : HexColor('#8e8e8e'),
                            animationController!.value),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
