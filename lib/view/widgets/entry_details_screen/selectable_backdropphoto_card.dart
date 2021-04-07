import 'package:flutter/material.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class SelectableBackdropPhotoCard extends StatelessWidget {
  final BackdropPhoto backdropPhoto;
  final void Function(int?) setSelectedImage;
  final bool selected;
  final double borderRadius;
  final AnimationController? animationController;
  const SelectableBackdropPhotoCard({
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
