import 'package:flutter/material.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:leitmotif/leitmotif.dart';

/// A screen widget to display additional information about a provided backdrop
/// photo.
///
/// The details include the photo's photographer, the location, and the
/// publishing date.
class BackdropPhotoDetailScreen extends StatelessWidget {
  final BackdropPhoto backdropPhoto;

  /// Creates a [BackdropPhotoDetailScreen].
  ///
  /// * [backdropPhoto] is the backdrop photo whose details will be displayed.
  const BackdropPhotoDetailScreen({
    Key? key,
    required this.backdropPhoto,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      appBar: MinimalistAppBar(
        backButtonBackgroundColor: Colors.white24,
      ),
      body: Stack(
        children: [
          _Background(backdropPhoto: backdropPhoto),
          ScrollableColumn(
            children: [
              SizedBox(
                height: MinimalistAppBar.height,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage(
                    "${backdropPhoto.assetUrl}",
                  ),
                  fit: BoxFit.scaleDown,

                  //color: Colors.black,
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(0, -12.0, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _DetailsCard(
                    backdropPhoto: backdropPhoto,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

/// The card widget to display the text-based information.
class _DetailsCard extends StatelessWidget {
  final BackdropPhoto backdropPhoto;

  const _DetailsCard({
    Key? key,
    required this.backdropPhoto,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitElevatedCard(
      borderRadius: BorderRadius.all(
        Radius.circular(
          16.0,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HOMLocalizations(context).details,
                textAlign: TextAlign.left,
                style: LitTextStyles.sansSerifHeader,
              ),
              _BackdropCardDetailItem(
                icon: LitIcons.person,
                detailLabel: HOMLocalizations(context).creator,
                detailValue: "${backdropPhoto.photographer}",
                constraints: constraints,
              ),
              _BackdropCardDetailItem(
                icon: LitIcons.map_marker,
                detailLabel: HOMLocalizations(context).location,
                detailValue: "${backdropPhoto.location}",
                constraints: constraints,
              ),
              _BackdropCardDetailItem(
                detailLabel: HOMLocalizations(context).published.capitalize(),
                detailValue: DateTime.parse(backdropPhoto.published!)
                    .formatAsLocalizedDateWithWeekday(context),
                constraints: constraints,
              ),
              backdropPhoto.description != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8.0,
                            ),
                            child: Text(
                              HOMLocalizations(context).backdropPhotoDesc,
                              style: LitTextStyles.sansSerifSmallHeader,
                            ),
                          ),
                          Text(
                            "${backdropPhoto.description}",
                            style: LitTextStyles.sansSerifBody,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }
}

/// The background layer of the screen, which includes a blurred version of the
/// backdrop photo.
class _Background extends StatefulWidget {
  final BackdropPhoto backdropPhoto;

  const _Background({
    Key? key,
    required this.backdropPhoto,
  }) : super(key: key);
  @override
  __BackgroundState createState() => __BackgroundState();
}

class __BackgroundState extends State<_Background>
    with TickerProviderStateMixin {
  late AnimationController _transformAnimation;
  Size get _deviceSize {
    return MediaQuery.of(context).size;
  }

  /// The background layer's transformation.
  ///
  /// It's values are set using the current animation value.
  Matrix4 get _transform {
    double scaling = 1.2 - (0.10 * _transformAnimation.value);
    double xTranslate = -20 + (20 * _transformAnimation.value);
    return Matrix4.identity()
      ..scale(
        scaling,
        scaling,
      )
      ..multiply(
        Matrix4.translationValues(
          xTranslate,
          0,
          0,
        ),
      );
  }

  @override
  void initState() {
    _transformAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 6000,
      ),
    );
    _transformAnimation.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _transformAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _transformAnimation,
          builder: (context, _) {
            return Container(
              height: _deviceSize.height,
              width: _deviceSize.width,
              child: Transform(
                transform: _transform,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: alternativeBoxFit(
                        _deviceSize,
                        portraitBoxFit: BoxFit.fitHeight,
                        landscapeBoxFit: BoxFit.fitWidth,
                      ),
                      image: AssetImage(
                        widget.backdropPhoto.assetUrl!,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        BluredBackgroundContainer(
          child: Container(
            color: Colors.white10,
            height: _deviceSize.height,
            width: _deviceSize.width,
          ),
          blurRadius: 4.0,
        ),
        Container(
          height: _deviceSize.height,
          width: _deviceSize.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white24,
                Colors.white10,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A card item to display information. The information can also be visualized
/// using an optional icon.
class _BackdropCardDetailItem extends StatelessWidget {
  final IconData? icon;
  final String detailLabel;
  final String detailValue;
  final BoxConstraints constraints;
  const _BackdropCardDetailItem({
    Key? key,
    this.icon,
    required this.detailLabel,
    required this.detailValue,
    required this.constraints,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon != null
              ? SizedBox(
                  width: constraints.maxWidth * 0.05,
                  child: Icon(
                    icon,
                    size: 16.0,
                    color: LitColors.mediumGrey,
                  ),
                )
              : SizedBox(),
          SizedBox(
            width: constraints.maxWidth * 0.35,
            child: Padding(
              padding: EdgeInsets.only(left: icon != null ? 4.0 : 0),
              child: ClippedText(
                "$detailLabel",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: LitTextStyles.sansSerifSmallHeader,
              ),
            ),
          ),
          SizedBox(
            width: constraints.maxWidth * (icon != null ? 0.60 : 0.65),
            child: ClippedText(
              "$detailValue",
              maxLines: 1,
              textAlign: TextAlign.right,
              style: LitTextStyles.sansSerifBody,
            ),
          ),
        ],
      ),
    );
  }
}
