part of widgets;

/// A button widget allowing to pick image files.
class PickPhotosButton extends StatelessWidget {
  final void Function() onPressed;

  /// Creates a [PickPhotosButton].
  const PickPhotosButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitPushedThroughButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LitIcons.photos,
            color: LitColors.grey500,
            size: 16.0,
          ),
          SizedBox(width: 8.0),
          Text(
            AppLocalizations.of(context).pickPhotoLabel.toUpperCase(),
            style: LitSansSerifStyles.button,
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
