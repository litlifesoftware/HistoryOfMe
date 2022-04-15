part of widgets;

/// A dialog `widget` displaying a preview of the provided image's path.
class ImagePreviewDialog extends StatefulWidget {
  /// The images's path.
  final String path;

  /// Creates a [ImagePreviewDialog].
  const ImagePreviewDialog({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<ImagePreviewDialog> {
  /// Pops the dialog from the navigation stack.
  void _onTap() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black38,
      insetPadding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: _onTap,
        child: Container(
          child: Image.file(
            File(
              widget.path,
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
