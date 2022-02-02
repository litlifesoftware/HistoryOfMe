part of widgets;

class ChangePhotoDialog extends StatefulWidget {
  final double borderRadius;
  final List<BackdropPhoto> backdropPhotos;
  final DiaryEntry diaryEntry;
  final double minHeight;
  const ChangePhotoDialog({
    Key? key,
    this.borderRadius = 16.0,
    required this.backdropPhotos,
    required this.diaryEntry,
    this.minHeight = 348.0,
  }) : super(key: key);

  @override
  _ChangePhotoDialogState createState() => _ChangePhotoDialogState();
}

class _ChangePhotoDialogState extends State<ChangePhotoDialog>
    with TickerProviderStateMixin {
  late AnimationController _appearAnimationController;
  late int _selectedImage;

  bool _isSelected(int? value) {
    return _selectedImage == value;
  }

  void setSelectedImage(int? value) {
    if (!_isSelected(value)) {
      setState(() {
        if (App.DEBUG) print("Selected backdrop id: $value");
        AppAPI().updateDiaryEntryBackdrop(widget.diaryEntry, value!);
        _selectedImage = value;
      });
      _appearAnimationController.forward(from: 0.0);
      print(value);
    } else {
      if (App.DEBUG) print("Already Selected");
    }
  }

  List<Widget> get _listItems {
    List<Widget> children = [];
    for (int i = 0; i < widget.backdropPhotos.length; i++) {
      children.add(
        _BackdropPhotoSelectableItem(
          backdropPhoto: widget.backdropPhotos[i],
          setSelectedImage: setSelectedImage,
          selected: _isSelected(widget.backdropPhotos[i].id),
          animationController: _appearAnimationController,
        ),
      );
    }
    return children;
  }

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.diaryEntry.backdropPhotoId;
    _appearAnimationController = AnimationController(
      duration: Duration(milliseconds: 130),
      vsync: this,
    );
    _appearAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(24.0),
        topRight: const Radius.circular(24.0),
      ),
      titleText: AppLocalizations.of(context).choosePhotoLabel,
      minHeight: widget.minHeight,
      // leading: DialogBackButton(
      //   onPressed: LitRouteController(context).closeDialog,
      // ),
      child: Builder(
        builder: (
          BuildContext context,
        ) {
          return SizedBox(
            height: widget.minHeight,
            child: LitScrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: _listItems,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BackdropPhotoSelectableItem extends StatelessWidget {
  final BackdropPhoto backdropPhoto;
  final bool selected;
  final AnimationController animationController;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;
  final void Function(int?) setSelectedImage;
  const _BackdropPhotoSelectableItem({
    Key? key,
    required this.backdropPhoto,
    required this.selected,
    required this.animationController,
    this.borderRadius = const BorderRadius.all(
      const Radius.circular(16.0),
    ),
    this.boxShadow = const [
      const BoxShadow(
        blurRadius: 13.0,
        color: Colors.black45,
        offset: Offset(2, 2),
        spreadRadius: 1.0,
      ),
    ],
    required this.setSelectedImage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CleanInkWell(
      onTap: () {
        setSelectedImage(backdropPhoto.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 32.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: selected ? boxShadow : [],
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset(
                      backdropPhoto.assetUrl!,
                      height: 150.0,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              selected
                  ? _SelectedPhotoOverlay(
                      animationController: animationController,
                      borderRadius: borderRadius,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedPhotoOverlay extends StatelessWidget {
  final AnimationController animationController;
  final BorderRadius borderRadius;

  const _SelectedPhotoOverlay({
    Key? key,
    required this.animationController,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return AnimatedOpacity(
          duration: animationController.duration!,
          opacity: animationController.value,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black54,
                        LitColors.lightPink.withOpacity(
                          0.8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: LitBadge(
                          child: ScaledDownText(
                            LeitmotifLocalizations.of(context)
                                .selectedLabel
                                .capitalize(),
                            style: LitTextStyles.sansSerif.copyWith(
                              fontSize: 15,
                              letterSpacing: -0.22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
