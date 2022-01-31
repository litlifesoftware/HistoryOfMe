part of widgets;

class EntryDetailBackdrop extends StatefulWidget {
  final bool? loading;
  final List<BackdropPhoto> backdropPhotos;
  final DiaryEntry diaryEntry;
  //final double height;
  const EntryDetailBackdrop({
    Key? key,
    required this.loading,
    required this.backdropPhotos,
    required this.diaryEntry,
    //required this.height,
  }) : super(key: key);

  static const height = 256.0;

  @override
  State<EntryDetailBackdrop> createState() => _EntryDetailBackdropState();
}

class _EntryDetailBackdropState extends State<EntryDetailBackdrop> {
  double get _backdropRelativeHeight =>
      EntryDetailBackdrop.height / MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: EntryDetailBackdrop.height,
            decoration: widget.loading!
                ? BoxDecoration(
                    color: LitColors.white,
                  )
                : BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        BackdropPhotoController(
                          widget.backdropPhotos,
                          widget.diaryEntry,
                        ).findBackdropPhotoUrl()!,
                      ),
                    ),
                  ),
          ),
          _GradientOverlay(
            //       constraints: constraints,
            relativeHeight: _backdropRelativeHeight,
          ),
        ],
      ),
    );
  }
}

/// A widget displaying a gradient overlay to create a smooth transition from
/// the image to the screen background color.
class _GradientOverlay extends StatelessWidget {
  /// The relative height the gradient should take up on the screen.
  final double relativeHeight;
  //final BoxConstraints constraints;

  const _GradientOverlay({
    Key? key,
    required this.relativeHeight,
    //  required this.constraints,
  }) : super(key: key);

  List<double> get _stops => [
        0,
        relativeHeight / 2,
        relativeHeight,
        1.0,
      ];

  List<Color> get _colors => [
        Colors.transparent,
        Colors.transparent,
        Colors.black,
        Colors.white,
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _colors,
          stops: _stops,
        ),
      ),
    );
  }
}
