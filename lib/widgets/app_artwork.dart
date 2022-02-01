part of widgets;

class AppArtwork extends StatefulWidget {
  final double width;

  const AppArtwork({
    Key? key,
    this.width = 280.0,
  }) : super(key: key);

  @override
  _AppArtworkState createState() => _AppArtworkState();
}

class _AppArtworkState extends State<AppArtwork> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Stack(
        //alignment: Alignment.center,
        children: [
          Image(
            image: AssetImage(
              "assets/images/Window.png",
            ),
            fit: BoxFit.scaleDown,

            //color: Colors.black,
          ),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: widget.width * 0.4,
                    child: Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        (widget.width * 0.306) +
                            (-10.0 + (20.0 * _animationController.value)),
                        0.0,
                      ),
                      child: Image(
                        image: AssetImage(
                          "assets/images/Cloud.png",
                        ),
                        fit: BoxFit.scaleDown,

                        //color: Colors.black,
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
