part of widgets;

class AppLauncherIconArt extends StatelessWidget {
  final double height;
  final double width;
  final List<BoxShadow> boxShadow;
  const AppLauncherIconArt({
    Key? key,
    this.height = 96.0,
    this.width = 96.0,
    this.boxShadow = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(height / 3),
          ),
          color: Color(0xffffefe1),
          boxShadow: boxShadow,
        ),
        child: Image(
          image: AssetImage(
            AppAssets.appIconAdaptive,
          ),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
