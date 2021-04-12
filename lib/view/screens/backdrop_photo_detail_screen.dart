import 'package:flutter/material.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class BackdropPhotoDetailScreen extends StatefulWidget {
  final BackdropPhoto backdropPhoto;

  const BackdropPhotoDetailScreen({
    Key? key,
    required this.backdropPhoto,
  }) : super(key: key);

  @override
  _BackdropPhotoDetailScreenState createState() =>
      _BackdropPhotoDetailScreenState();
}

class _BackdropPhotoDetailScreenState extends State<BackdropPhotoDetailScreen> {
  Size get _deviceSize {
    return MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      appBar: MinimalistAppBar(),
      body: Stack(
        children: [
          Container(
            height: _deviceSize.height,
            width: _deviceSize.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: alternativeBoxFit(
                _deviceSize,
                portraitBoxFit: BoxFit.fitHeight,
                landscapeBoxFit: BoxFit.fitWidth,
              ),
              image: AssetImage(
                "${widget.backdropPhoto.assetUrl}",
              ),
            )),
          ),
          BluredBackgroundContainer(
            child: Container(
              color: Colors.white10,
              height: _deviceSize.height,
              width: _deviceSize.width,
            ),
            blurRadius: 8.0,
          ),
          ScrollableColumn(
            children: [
              SizedBox(
                height: MinimalistAppBar.height,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage(
                    "${widget.backdropPhoto.assetUrl}",
                  ),
                  fit: BoxFit.scaleDown,

                  //color: Colors.black,
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(0, -14.0, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: LitElevatedCard(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          16.0,
                        ),
                      ),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Details",
                              textAlign: TextAlign.left,
                              style: LitTextStyles.sansSerifHeader,
                            ),
                            _BackdropCardDetailItem(
                              icon: LitIcons.person,
                              detailLabel: "Photographer",
                              detailValue:
                                  "${widget.backdropPhoto.photographer}",
                              constraints: constraints,
                            ),
                            widget.backdropPhoto.description != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "${widget.backdropPhoto.photographer} is telling us about this image:\n",
                                            style: LitTextStyles
                                                .sansSerifSmallHeader,
                                          ),
                                          TextSpan(
                                            text:
                                                "${widget.backdropPhoto.description}",
                                            style: LitTextStyles.sansSerifBody,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        );
                      })),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _BackdropCardDetailItem extends StatelessWidget {
  final IconData icon;
  final String detailLabel;
  final String detailValue;
  final BoxConstraints constraints;
  const _BackdropCardDetailItem({
    Key? key,
    required this.icon,
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
          SizedBox(
            width: constraints.maxWidth * 0.05,
            child: Icon(
              icon,
              size: 16.0,
              color: LitColors.mediumGrey,
            ),
          ),
          SizedBox(
            width: constraints.maxWidth * 0.35,
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: ClippedText(
                "$detailLabel",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: LitTextStyles.sansSerifSmallHeader,
              ),
            ),
          ),
          SizedBox(
            width: constraints.maxWidth * 0.60,
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
