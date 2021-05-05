import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/data/constants.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class ChangePhotoDialog extends StatefulWidget {
  // final List<String> imageNames;
  final double borderRadius;
  final List<BackdropPhoto> backdropPhotos;
  final DiaryEntry diaryEntry;
  final double minHeight;
  const ChangePhotoDialog({
    Key? key,
    //@required this.imageNames,
    this.borderRadius = 16.0,
    required this.backdropPhotos,
    required this.diaryEntry,
    this.minHeight = 384.0,
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
        if (debug) print("Selected backdrop id: $value");
        HiveDBService().updateDiaryEntryBackdrop(widget.diaryEntry, value!);
        _selectedImage = value;
      });
      _appearAnimationController.forward(from: 0.0);
      print(value);
    } else {
      if (debug) print("Already Selected");
    }
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
      titleText: "Choose a photo",
      minHeight: widget.minHeight,
      leading:
          DialogBackButton(onPressed: LitRouteController(context).closeDialog),
      child: Builder(
        builder: (
          BuildContext context,
        ) {
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
          return SizedBox(
            height: widget.minHeight,
            child: LitScrollbar(
              child: ScrollableColumn(
                children: children,
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
  final void Function(int?) setSelectedImage;
  final bool selected;
  final double borderRadius;
  final AnimationController? animationController;
  const _BackdropPhotoSelectableItem({
    Key? key,
    required this.backdropPhoto,
    required this.setSelectedImage,
    required this.selected,
    this.borderRadius = 16.0,
    required this.animationController,
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
            boxShadow: selected
                ? [
                    BoxShadow(
                      blurRadius: 13.0,
                      color: Colors.black45,
                      offset: Offset(2, 2),
                      spreadRadius: 1.0,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      backdropPhoto.assetUrl!,
                      height: 150.0,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              selected
                  ? AnimatedBuilder(
                      animation: animationController!,
                      builder: (context, child) {
                        return AnimatedOpacity(
                          duration: animationController!.duration!,
                          opacity: animationController!.value,
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.black54,
                                            LitColors.lightPink
                                                .withOpacity(0.8),
                                          ])),
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 24.0,
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          "Selected",
                                          style:
                                              LitTextStyles.sansSerif.copyWith(
                                            fontSize: 16.5,
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
                            ],
                          ),
                        );
                      },
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
