part of widgets;

/// A History of Me widget displaying the bookmark's title, which is derived
/// by the provided username.
class BookmarkTitle extends StatelessWidget {
  /// Creates a [BookmarkTitle].

  /// The [UserData] containing the username.
  final UserData userData;

  /// Specifies the surrounding [BorderRadius].
  final BorderRadiusGeometry borderRadius;

  /// Specifies the alignment on the bookmark.
  final Alignment alignment;

  const BookmarkTitle({
    Key? key,
    required this.userData,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(6.0),
      bottomLeft: Radius.circular(6.0),
    ),
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: alignment,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              decoration: BoxDecoration(
                color: LitColors.grey120,
                borderRadius: borderRadius,
              ),
              child: Stack(
                children: [
                  _KeyIcon(constraints: constraints),
                  _HistoryOfLabel(userData: userData),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A History of Me widget displaying the `History Of Me`'s key icon.
class _KeyIcon extends StatelessWidget {
  final BoxConstraints constraints;

  /// Creates a [_KeyIcon].
  const _KeyIcon({
    Key? key,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4.0,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Image(
          color: LitColors.grey150,
          image: AssetImage(
            AppAssets.keyLogo,
          ),
          fit: BoxFit.fitHeight,
          //color: Colors.black,
          height: constraints.maxHeight * 0.8,
        ),
      ),
    );
  }
}

/// A History of Me widget displaying a stylized `History of` label.
class _HistoryOfLabel extends StatelessWidget {
  final UserData userData;

  /// Creates a [_HistoryOfLabel].
  const _HistoryOfLabel({
    Key? key,
    required this.userData,
  }) : super(key: key);

  /// A constant string stating `History` due to it being the same on all
  /// locales.
  static const historyLabel = "History";

  /// A constant string stating `of` due to it being the same on all
  /// locales.
  static const ofLabel = "of";

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: ScaledDownText(
                    ofLabel,
                    style: LitSerifStyles.caption.copyWith(
                      fontSize: 8.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ScaledDownText(
                  historyLabel,
                  style: LitSerifStyles.caption.copyWith(
                    fontSize: 8.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: ClippedText(
                userData.name,
                style: LitSerifStyles.subtitle2.copyWith(
                  fontSize: 11.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
