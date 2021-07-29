import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:leitmotif/leitmotif.dart';

/// A container widget displaying the user's name alongside a stylized
/// `History of` label on a color background.
///
/// The wrapping container will ensure no overflow will occur.
class BookmarkTitle extends StatelessWidget {
  /// Creates a [BookmarkTitle].
  const BookmarkTitle({
    Key? key,
    required this.userData,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
    ),
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  /// The [UserData] containing the username.
  final UserData? userData;

  /// Specifies the surrounding [BorderRadius].
  final BorderRadiusGeometry borderRadius;

  /// Specifies the alignment on the bookmark (defaults to
  /// `Alignment.centerLeft`).
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor('#eae8e8'),
            borderRadius: borderRadius,
          ),
          child: RotatedBox(
            quarterTurns: 1,
            child: Stack(
              children: [
                _KeyIcon(),
                _HistoryOfLabel(userData: userData!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget displaying the `History Of Me`'s key icon.
class _KeyIcon extends StatelessWidget {
  /// Creates a [_KeyIcon].
  const _KeyIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 52.0),
      child: Align(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage(
            "assets/images/History_Of_Me_Key_64px-01.png",
          ),
          fit: BoxFit.fitHeight,
          //color: Colors.black,
          height: 24.0,
        ),
      ),
    );
  }
}

/// A widget displaying a stylized `History of [username]` label.
class _HistoryOfLabel extends StatelessWidget {
  final UserData userData;

  /// Creates a [_HistoryOfLabel].
  const _HistoryOfLabel({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
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
                    "of",
                    style: LitTextStyles.serif.copyWith(
                      fontSize: 8.0,
                      color: HexColor('#9b9b9b'),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ScaledDownText(
                  "History",
                  style: LitTextStyles.serif.copyWith(
                    fontSize: 10.0,
                    color: HexColor('#9b9b9b'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClippedText(
                "${userData.name}",
                style: LitTextStyles.serif.copyWith(
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
