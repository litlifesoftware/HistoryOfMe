import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/data/constants.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/view/widgets/entry_details_screen/selectable_backdropphoto_card.dart';
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
  AnimationController? _appearAnimationController;
  int? _selectedImage;

  // List<BackdropPhoto> parseBackdropPhotos(String assetData) {
  //   final parsed = jsonDecode(assetData).cast<Map<String, dynamic>>();

  //   return parsed
  //       .map<BackdropPhoto>((json) => BackdropPhoto.fromJson(json))
  //       .toList();
  // }

  // Future<List<BackdropPhoto>> loadPhotosFromJson() async {
  //   String data =
  //       await rootBundle.loadString('assets/json/image_collection_data.json');
  //   return parseBackdropPhotos(data);
  // }

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
      _appearAnimationController!.forward(from: 0.0);
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
    _appearAnimationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: "Choose a photo",
      minHeight: widget.minHeight,
      child: Builder(
        builder: (
          BuildContext context,
        ) {
          List<Widget> children = [];
          for (int i = 0; i < widget.backdropPhotos.length; i++) {
            children.add(
              SelectableBackdropPhotoCard(
                backdropPhoto: widget.backdropPhotos[i],
                setSelectedImage: setSelectedImage,
                selected: _isSelected(widget.backdropPhotos[i].id),
                animationController: _appearAnimationController,
              ),
            );
          }
          return SizedBox(
            height: widget.minHeight,
            child: ScrollableColumn(
              children: children,
            ),
          );
        },
      ),
    );
  }
}
