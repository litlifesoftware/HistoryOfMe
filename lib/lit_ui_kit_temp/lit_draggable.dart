import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LitDraggable extends StatefulWidget {
  final Widget child;
  final Offset initialDragOffset;
  const LitDraggable({
    Key key,
    @required this.child,
    this.initialDragOffset = const Offset(0.0, 0.0),
  }) : super(key: key);
  @override
  _LitDraggableState createState() => _LitDraggableState();
}

class _LitDraggableState extends State<LitDraggable>
    with TickerProviderStateMixin {
  AnimationController _dragAnimationController;

  //Offset draggedOffset = Offset(0, 0);
  double draggedDx;
  double draggedDy;

  void _setDraggedOffset(double dx, double dy) {
    _dragAnimationController
        .reverse()
        .then((value) => _dragAnimationController.forward());
    setState(() {
      draggedDx = dx;
      draggedDy = dy;
    });
  }

  bool isOnScreen(DraggableDetails details) {
    return MediaQuery.of(context).size.height > details.offset.dy &&
        MediaQuery.of(context).size.width > details.offset.dx &&
        details.offset.dy > 0 &&
        details.offset.dx > 0;
  }

  void _onDragEnd(Offset dragEndOffset) {
    final double adjustedHeight =
        MediaQuery.of(context).size.height - oldSize.height - 30;
    final double adjustedWidth =
        MediaQuery.of(context).size.width - oldSize.width;
    print("Dragged dx:${dragEndOffset.dx} dy:${dragEndOffset.dy}");
    print("Size dx: $adjustedWidth dy:$adjustedHeight");
    // If dragged inside viewable screen area
    if (dragEndOffset.dx > 0 && dragEndOffset.dy > 0) {
      if (dragEndOffset.dx < adjustedWidth &&
          dragEndOffset.dy < adjustedHeight) {
        _setDraggedOffset(dragEndOffset.dx, dragEndOffset.dy);
      } else {
        if (dragEndOffset.dx > adjustedWidth &&
            dragEndOffset.dy > adjustedHeight) {
          _setDraggedOffset(adjustedWidth, adjustedHeight);
        }

        if (dragEndOffset.dx > adjustedWidth &&
            dragEndOffset.dy < adjustedHeight) {
          _setDraggedOffset(adjustedWidth, dragEndOffset.dy);
        }

        if (dragEndOffset.dx < adjustedWidth &&
            dragEndOffset.dy > adjustedHeight) {
          _setDraggedOffset(dragEndOffset.dx, adjustedHeight);
        }
      }
    } else {
      if (dragEndOffset.dx < 0 && dragEndOffset.dy < 0) {
        _setDraggedOffset(0, 0);
      }

      if (dragEndOffset.dx < 0 && dragEndOffset.dy > 0) {
        if (dragEndOffset.dy < adjustedHeight) {
          _setDraggedOffset(0, dragEndOffset.dy);
        } else {
          _setDraggedOffset(0, adjustedHeight);
        }
      }

      if (dragEndOffset.dx > 0 && dragEndOffset.dy < 0) {
        if (dragEndOffset.dx > adjustedWidth) {
          _setDraggedOffset(adjustedWidth, 0);
        } else {
          _setDraggedOffset(dragEndOffset.dx, 0);
        }
      }
    }

    // _setDraggedOffset(dragEndOffset.dx, dragEndOffset.dy);
  }

  GlobalKey<State<StatefulWidget>> widgetKey = GlobalKey();
  Size oldSize = Size(0.0, 0.0);

  void postFrameCallback(_) {
    BuildContext context = widgetKey.currentContext;
    if (context == null) return;

    Size newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
  }

  @override
  void initState() {
    super.initState();
    draggedDx = widget.initialDragOffset.dx;
    draggedDy = widget.initialDragOffset.dy;
    _dragAnimationController =
        AnimationController(duration: Duration(milliseconds: 120), vsync: this);

    _dragAnimationController.forward();
  }

  @override
  void dispose() {
    _dragAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: AnimatedBuilder(
        animation: _dragAnimationController,
        builder: (context, _) {
          return Positioned(
            left: draggedDx,
            top: draggedDy,
            // child: Draggable(
            //     feedback: FloatingActionButton(
            //         child: Icon(Icons.drag_handle), onPressed: () {}),
            //     child: FloatingActionButton(
            //         child: Icon(Icons.drag_handle), onPressed: () {}),
            //     childWhenDragging: Container(),
            //     onDragEnd: _onButtonDragEnd),

            child: Draggable(
              feedback: _Feedback(child: widget.child),
              child: widget.child,
              childWhenDragging: SizedBox(),
              onDragEnd: (details) {
                _onDragEnd(details.offset);
              },
            ),
          );
        },
      ),
    );
  }
}

class _Feedback extends StatefulWidget {
  final Widget child;
  const _Feedback({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  __FeedbackState createState() => __FeedbackState();
}

class __FeedbackState extends State<_Feedback> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 140), vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        child: Opacity(
          opacity: 0.5,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Transform.scale(
                scale: 0.5 + (_animationController.value * 0.5),
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}
