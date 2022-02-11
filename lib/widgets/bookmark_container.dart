part of widgets;

class BookmarkFittedBox extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  final BoxDecoration boxDecoration;
  const BookmarkFittedBox({
    Key? key,
    required this.maxWidth,
    required this.child,
    this.boxDecoration = const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(-3.0, 3.0),
          blurRadius: 8.0,
          spreadRadius: 1.0,
        )
      ],
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: AspectRatio(
        aspectRatio: BookmarkCover.aspectRatio,
        child: Container(
          decoration: boxDecoration,
          child: child,
        ),
      ),
    );
  }
}
