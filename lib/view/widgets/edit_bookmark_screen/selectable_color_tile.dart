import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class SelectableColorTile extends StatefulWidget {
  final Color color;
  final List<BoxShadow> boxShadow;
  final double height;
  final double width;
  final bool selected;
  final void Function(Color) onSelectCallback;

  const SelectableColorTile({
    Key? key,
    required this.color,
    this.boxShadow = const [],
    required this.height,
    required this.width,
    required this.selected,
    required this.onSelectCallback,
  }) : super(key: key);

  @override
  _SelectableColorTileState createState() => _SelectableColorTileState();
}

class _SelectableColorTileState extends State<SelectableColorTile>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  void _onSelect() {
    _animationController.reverse(from: 1.0).then(
          (_) => _animationController.forward().then(
                (__) => widget.onSelectCallback(widget.color),
              ),
        );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 120),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return InkWell(
            onTap: _onSelect,
            child: SizedBox(
              height: widget.height,
              width: widget.width,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.lerp(Colors.white, widget.color,
                              (_animationController.value) * 0.85),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: widget.boxShadow,
                        ),
                      ),
                      widget.selected
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      6.0,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0,
                                    vertical: 6.0,
                                  ),
                                  child: Icon(
                                    LitIcons.check,
                                    color: LitColors.mediumGrey,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  )),
            ),
          );
        });
  }
}
