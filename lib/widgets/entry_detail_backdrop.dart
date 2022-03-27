part of widgets;

class EntryDetailBackdrop extends StatefulWidget {
  // final bool? loading;
  // final List<BackdropPhoto> backdropPhotos;
  final DiaryEntry diaryEntry;
  //final List<XFile> images;
  //final double height;
  final DiaryPhotoPicker diaryPhotoPicker;

  const EntryDetailBackdrop({
    Key? key,
    //  required this.loading,
    //  required this.backdropPhotos,
    //required this.images,
    required this.diaryEntry,
    required this.diaryPhotoPicker,
    //required this.height,
  }) : super(key: key);

  static const height = 256.0;

  @override
  State<EntryDetailBackdrop> createState() => _EntryDetailBackdropState();
}

class _EntryDetailBackdropState extends State<EntryDetailBackdrop>
    with TickerProviderStateMixin {
  double get _backdropRelativeHeight =>
      EntryDetailBackdrop.height / MediaQuery.of(context).size.height;
  late AnimationController animationController;

  List<DiaryPhoto> get photos => widget.diaryEntry.photos ?? [];

  //
  // bool doesFileExit(DiaryPhoto photo) {
  //   return File(
  //     photo.path,
  //   ).existsSync();
  // }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 5000,
      ),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                photos.length > 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: EntryDetailBackdrop.height + 128,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: photos.length,
                          itemBuilder: ((context, index) {
                            // print("name: " + photos[index].name);
                            // print("path: " + photos[index].path);
                            return widget.diaryPhotoPicker
                                    .imageFileExists(photos[index])
                                ? InkWell(
                                    onTap: () => {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          backgroundColor: Colors.black38,
                                          insetPadding: EdgeInsets.all(8.0),
                                          child:
                                              // imageFromBase64String(base1),
                                              InkWell(
                                            onTap: (() => {
                                                  Navigator.of(context).pop(),
                                                }),
                                            child: Container(
                                              child: Image.file(
                                                //    File(widget.images[index].path),
                                                File(
                                                  photos[index].path,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: EntryDetailBackdrop.height + 128,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.file(
                                          //    File(widget.images[index].path),
                                          File(
                                            photos[index].path,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: EntryDetailBackdrop.height + 128,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 64),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "This photo is unavailable",
                                                style: LitSansSerifStyles.body2
                                                    .copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16.0,
                                              ),
                                              InkWell(
                                                splashColor: Colors.white,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white12,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        16.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Icon(
                                                      LitIcons.info,
                                                      color: Colors.white,
                                                      size: 18.0,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return LitTitledDialog(
                                                        titleText:
                                                            "Photo unavailable",
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 16.0,
                                                        ),
                                                        minHeight: 128.0,
                                                        child:
                                                            LitDescriptionTextBox(
                                                          maxLines: 6,
                                                          text:
                                                              "This photo is not available anymore. It probably was not found when this diary was restored. But you may are able to find the photo on your device. Import it into this diary entry by pressing the 'Select' button.",
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                        ),
                      )
                    : AnimatedBuilder(
                        animation: animationController,
                        child: Container(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: EntryDetailBackdrop.height + 128,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 64),
                                child: Text(
                                  "No images available",
                                  style: LitSansSerifStyles.body2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.06 - (animationController.value * 0.06),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.lerp(
                                      Color(widget.diaryEntry.hashCode),
                                      Colors.grey,
                                      animationController.value,
                                    )!,
                                    Color.lerp(
                                      Color(widget.diaryEntry.hashCode),
                                      Colors.lightGreen,
                                      animationController.value,
                                    )!,
                                  ],
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                      )
                // widget.diaryEntry.photos != null &&
                //         widget.diaryEntry.photos!.length == 1
                //     ? Container(
                //         width: MediaQuery.of(context).size.width,
                //         height: EntryDetailBackdrop.height + 128,
                //         decoration: BoxDecoration(
                //           image: DecorationImage(
                //             alignment: Alignment.topCenter,
                //             fit: BoxFit.fitWidth,
                //             image: FileImage(
                //               File(widget.diaryEntry.photos![0].title),
                //             ),
                //           ),
                //         ),
                //       )
                //     : SizedBox(),
              ],
            ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: EntryDetailBackdrop.height,
          //   decoration: widget.loading!
          //       ? BoxDecoration(
          //           color: LitColors.white,
          //         )
          //       : BoxDecoration(
          //           image: DecorationImage(
          //             alignment: Alignment.topCenter,
          //             fit: BoxFit.fitWidth,
          //             image: AssetImage(
          //               BackdropPhotoController(
          //                 widget.backdropPhotos,
          //                 widget.diaryEntry,
          //               ).findBackdropPhotoUrl()!,
          //             ),
          //           ),
          //         ),
          // ),
          // _GradientOverlay(
          //   //       constraints: constraints,
          //   relativeHeight: _backdropRelativeHeight,
          // ),
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
        relativeHeight / 1.5,
        relativeHeight,
        1.0,
      ];

  List<Color> get _colors => [
        Colors.transparent,
        Colors.black26,
        Colors.black45,
        //Colors.white,
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: EntryDetailBackdrop.height + 128,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _colors,
          //    stops: _stops,
        ),
      ),
    );
  }
}
