import 'package:flutter/material.dart';
import 'package:history_of_me/controller/backdrop_photo_controller.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class EntryDetailsBackdrop extends StatelessWidget {
  final bool? loading;
  final List<BackdropPhoto> backdropPhotos;
  final DiaryEntry diaryEntry;
  final double relativePortraitPhotoHeight;
  final double relativeLandscapePhotoHeight;
  const EntryDetailsBackdrop({
    Key? key,
    required this.loading,
    required this.backdropPhotos,
    required this.diaryEntry,
    required this.relativePortraitPhotoHeight,
    required this.relativeLandscapePhotoHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.black87,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height /
                  (alternativeHeight(MediaQuery.of(context).size,
                      portraitHeight: relativePortraitPhotoHeight,
                      landscapeHeight: relativeLandscapePhotoHeight)),
              decoration: loading!
                  ? BoxDecoration(color: LitColors.mediumGrey.withOpacity(0.2))
                  : BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(BackdropPhotoController(
                          backdropPhotos,
                          diaryEntry,
                        ).findBackdropPhotoUrl()!),
                      ),
                    ),
            ),
            _GradientBackgroundLayer(constraints: constraints),
          ],
        ),
      );
    });
  }
}

class _GradientBackgroundLayer extends StatelessWidget {
  final BoxConstraints constraints;

  const _GradientBackgroundLayer({
    Key? key,
    required this.constraints,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black87, Colors.black],
          stops: constraints.maxHeight > constraints.maxWidth
              ? [0.16, 0.28, 0.56]
              : [0.05, 0.76, 0.65],
        ),
      ),
    );
  }
}
