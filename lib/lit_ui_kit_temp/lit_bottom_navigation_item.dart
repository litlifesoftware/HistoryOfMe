import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitBottomNavigationItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData iconSelected;
  final bool selected;
  final void Function(int) setSelectedTab;
  final AnimationController animationController;
  const LitBottomNavigationItem({
    Key key,
    @required this.index,
    @required this.icon,
    @required this.iconSelected,
    @required this.selected,
    @required this.setSelectedTab,
    @required this.animationController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return AnimatedOpacity(
          opacity: animationController.value,
          duration: animationController.duration,
          child: InkWell(
              onTap: selected
                  ? () {}
                  : () {
                      setSelectedTab(index);
                    },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: selected
                          ? LitColors.mediumGrey
                          : LitColors.mediumGrey.withOpacity(0.3),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                blurRadius: 14.0,
                                color: Colors.black.withOpacity(0.4),
                              )
                            ]
                          : [],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: Icon(
                        selected ? iconSelected : icon,
                        color: Colors.white,
                        size: 22.0,
                      ),
                    ),
                  ),
                  selected && animationController.isAnimating
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            child: AnimatedOpacity(
                              duration: animationController.duration,
                              opacity:
                                  0.125 + (animationController.value * 0.875),
                              child: Transform(
                                transform: Matrix4.translationValues(
                                  0,
                                  10.0 - (10.0 * (animationController.value)),
                                  0,
                                ),
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        3,
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  selected && animationController.isCompleted
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 8.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  4,
                                ),
                              ),
                              color: LitColors.lightPink,
                            ),
                            height: 8,
                            width: 8,
                          ),
                        )
                      : SizedBox(),
                ],
              )),
        );
      },
    );
  }
}
