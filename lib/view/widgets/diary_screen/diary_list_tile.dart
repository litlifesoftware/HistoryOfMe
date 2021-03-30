import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/controller/routes/screen_router.dart';
import 'package:history_of_me/data/constants.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:intl/intl.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';

class DiaryListTile extends StatefulWidget {
  final AnimationController? animationController;
  final int listIndex;
  final DiaryEntry diaryEntry;
  final double landscapeWidthFactor;
  const DiaryListTile({
    Key? key,
    required this.animationController,
    required this.listIndex,
    required this.diaryEntry,
    this.landscapeWidthFactor = 0.75,
  }) : super(key: key);

  @override
  _DiaryListTileState createState() => _DiaryListTileState();
}

class _DiaryListTileState extends State<DiaryListTile> {
  late ScreenRouter _screenRouter;

  void _onTilePressed() {
    _screenRouter.toDiaryEntryDetailScreen(
      listIndex: widget.listIndex,
      diaryEntryUid: widget.diaryEntry.uid,
    );
  }

  @override
  void initState() {
    super.initState();
    _screenRouter = ScreenRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    /// The [List] of month labels provided by the [CalendarLocalizationService].
    List<String> monthLabels;
    print(widget.diaryEntry.date);
    monthLabels = CalendarLocalizationService.getLocalizedCalendarMonths(
        Localizations.localeOf(context));
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (context, _) {
        widget.animationController!.forward();

        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / 50) * widget.listIndex, 1.0,
                    curve: Curves.easeInOut)));
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              -(MediaQuery.of(context).size.width *
                      (1 / 50) *
                      widget.listIndex) +
                  ((MediaQuery.of(context).size.width *
                          (1 / 50) *
                          widget.listIndex) *
                      animation.value),
              0,
              0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _EntryDateLabel(
                      boxShadowOffset: Offset(-2, 4),
                      quaterTurns: 3,
                      text: monthLabels[
                          DateTime.parse(widget.diaryEntry.date!).month - 1],
                      landscapeWidthFactor: widget.landscapeWidthFactor,
                    ),
                    _EntryCard(
                      listIndex: widget.listIndex,
                      diaryEntry: widget.diaryEntry,
                      landscapeWidthFactor: widget.landscapeWidthFactor,
                      onPressed: _onTilePressed,
                    ),
                    _EntryDateLabel(
                      boxShadowOffset: Offset(4, -2),
                      quaterTurns: 1,
                      text: DateTime.parse(widget.diaryEntry.date!)
                          .year
                          .toString(),
                      landscapeWidthFactor: widget.landscapeWidthFactor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EntryDateLabel extends StatelessWidget {
  final int quaterTurns;
  final String text;
  final Offset boxShadowOffset;
  final double landscapeWidthFactor;
  const _EntryDateLabel({
    Key? key,
    required this.quaterTurns,
    required this.text,
    required this.boxShadowOffset,
    required this.landscapeWidthFactor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final double portraitWidth = MediaQuery.of(context).size.width * 0.125;
    final double landscapeWidth = portraitWidth * landscapeWidthFactor;
    return SizedBox(
      width: alternativeWidth(
        deviceSize,
        portraitWidth: portraitWidth,
        landscapeWidth: landscapeWidth,
      ),
      height: 90.0,
      child: RotatedBox(
          quarterTurns: quaterTurns,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: HexColor('efefef'),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15.0,
                      offset: boxShadowOffset,
                      color: Colors.black.withOpacity(0.20),
                      spreadRadius: 2.0,
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 12.0,
                ),
                child: Center(
                    child: ClippedText(
                  "$text",
                  textAlign: TextAlign.center,
                  style: LitTextStyles.sansSerif.copyWith(
                    color: HexColor("bababa"),
                    letterSpacing: -0.12,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0,
                  ),
                )),
              ),
            ),
          )),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final int listIndex;
  final DiaryEntry diaryEntry;
  final double landscapeWidthFactor;
  final void Function() onPressed;
  const _EntryCard({
    Key? key,
    required this.listIndex,
    required this.diaryEntry,
    required this.landscapeWidthFactor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double portraitWidth = MediaQuery.of(context).size.width * 0.75;
        final double landscapeWidth = portraitWidth * landscapeWidthFactor;

        final RelativeDateTime relativeDateTime = RelativeDateTime(
          dateTime: DateTime.now(),
          other: DateTime.fromMillisecondsSinceEpoch(
            diaryEntry.lastUpdated!,
          ),
        );
        final RelativeDateFormat relativeDateFormatter = RelativeDateFormat(
          Localizations.localeOf(context),
        );
        return SizedBox(
          width: alternativeWidth(
            MediaQuery.of(context).size,
            portraitWidth: portraitWidth,
            landscapeWidth: landscapeWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LitPushedButton(
              onPressed: onPressed,
              minScale: 0.94,
              animateOnStart: false,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 4),
                          blurRadius: 12.0,
                          spreadRadius: 1.0,
                          color: Colors.black.withOpacity(0.22),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${diaryEntry.title != initialDiaryEntryTitle ? diaryEntry.title : "Untitled"}",
                            style: LitTextStyles.sansSerif.copyWith(
                              fontSize: 16.0,
                              letterSpacing: -0.02,
                              fontWeight: FontWeight.w600,
                              color: HexColor('444444'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                              top: 4.0,
                            ),
                            child: Container(
                              width:
                                  ((MediaQuery.of(context).size.width - 32.0) *
                                          0.75) -
                                      32.0,
                              height: 2.0,
                              color: HexColor('e0e0e0'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${DateFormat.yMMMMd(Intl.getCurrentLocale()).format(DateTime.parse(diaryEntry.date!))}",
                                style: LitTextStyles.sansSerif.copyWith(
                                  fontSize: 12.0,
                                  letterSpacing: -0.02,
                                  fontWeight: FontWeight.w600,
                                  color: HexColor('666666'),
                                ),
                              ),
                              Text(
                                "${relativeDateFormatter.format(relativeDateTime)}",
                                style: LitTextStyles.sansSerif.copyWith(
                                  fontSize: 11.0,
                                  letterSpacing: -0.02,
                                  fontWeight: FontWeight.w600,
                                  color: HexColor('7f7f7f'),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        8.0,
                      ),
                      child: Container(
                        height: 15.0,
                        width: 15.0,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            LitColors.lightRed,
                            HexColor('bee5be'),
                            diaryEntry.moodScore!,
                          ),
                          borderRadius: BorderRadius.circular(
                            5.95,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
