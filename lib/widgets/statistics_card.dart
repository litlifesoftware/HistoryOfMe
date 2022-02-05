part of widgets;

class StatisticsCard extends StatefulWidget {
  @override
  _StatisticsCardState createState() => _StatisticsCardState();
}

class _StatisticsCardState extends State<StatisticsCard> {
  late QueryController queryController;

  bool get _isAvailable {
    return queryController.totalDiaryEntries > 0;
  }

  @override
  void initState() {
    queryController = QueryController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isAvailable
        ? _StatisticsCardContent(
            queryController: queryController,
          )
        : _NoEntriesCard();
  }
}

class _NoEntriesCard extends StatelessWidget {
  const _NoEntriesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LitEdgeInsets.card,
      child: LitTitledActionCard(
        title: LeitmotifLocalizations.of(context).statisticsLabel,
        subtitle: AppLocalizations.of(context).noEntriesAvailLabel,
        child: Column(
          children: [
            LitDescriptionTextBox(
              text: AppLocalizations.of(context).statisticsFallbackDescr,
            ),
            Text(
              AppLocalizations.of(context).statisticsFallbackActionLabel,
              style: LitSansSerifStyles.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsItemCard extends StatelessWidget {
  final String value;
  final String label;
  final BoxConstraints constraints;
  const _StatisticsItemCard({
    Key? key,
    required this.value,
    required this.label,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: constraints.maxWidth / 2,
        maxWidth: constraints.maxWidth / 2,
        minHeight: 78.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            boxShadow: LitBoxShadows.md,
            color: Color(0xFFf8f8f8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.left,
                  style: LitSansSerifStyles.h6.copyWith(
                    color: LitColors.lightGrey,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  label,
                  textAlign: TextAlign.left,
                  style: LitSansSerifStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatisticsCardContent extends StatelessWidget {
  final QueryController queryController;
  const _StatisticsCardContent({
    Key? key,
    required this.queryController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitConstrainedSizedBox(
      landscapeWidthFactor: 0.65,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _StatisticsItemRow(
                        children: [
                          _StatisticsHeaderItem(
                            label:
                                AppLocalizations.of(context).diaryEntriesLabel,
                            value: queryController.totalDiaryEntries.toString(),
                            constraints: constraints,
                          ),
                          _StatisticsHeaderItem(
                            label: AppLocalizations.of(context).avgMoodLabel,
                            value: MoodTranslator(
                              moodScore: queryController.avgMood,
                              context: context,
                            ).label.capitalize(),
                            constraints: constraints,
                          ),
                        ],
                      ),
                      _StatisticsItemRow(
                        children: [
                          _StatisticsItemCard(
                            label:
                                AppLocalizations.of(context).wordsWrittenLabel,
                            value: queryController.totalWordsWritten.toString(),
                            constraints: constraints,
                          ),
                          _StatisticsItemCard(
                            label:
                                AppLocalizations.of(context).wordsPerEntryLabel,
                            value: queryController.avgWordWritten
                                .toStringAsFixed(2),
                            constraints: constraints,
                          ),
                        ],
                      ),
                      _StatisticsItemRow(
                        children: [
                          _StatisticsItemCard(
                            constraints: constraints,
                            label: AppLocalizations.of(context)
                                .mostWordsAtOnceLabel,
                            value: queryController.mostWordsWrittenAtOnce
                                .toString(),
                          ),
                          _StatisticsItemCard(
                            constraints: constraints,
                            label: AppLocalizations.of(context)
                                .fewestWordsAtOnceLabel,
                            value: queryController.leastWordsWrittenAtOnce
                                .toString(),
                          ),
                        ],
                      ),
                      _StatisticsItemRow(
                        children: [
                          _StatisticsItemCard(
                            constraints: constraints,
                            label: AppLocalizations.of(context)
                                .entriesThisWeekLabel,
                            value: queryController.entriesThisWeek.toString(),
                          ),
                          _StatisticsItemCard(
                            constraints: constraints,
                            label: AppLocalizations.of(context)
                                .entriesThisMonthLabel,
                            value: queryController.entriesThisMonth.toString(),
                          ),
                        ],
                      ),
                      _StatisticsItemRow(
                        children: [
                          _StatisticsItemCard(
                            label:
                                AppLocalizations.of(context).lastestEntryLabel,
                            value: queryController.latestEntryDate
                                .formatAsLocalizedDate(context),
                            constraints: constraints,
                          ),
                          _StatisticsItemCard(
                            label: AppLocalizations.of(context).firstEntryLabel,
                            value: queryController.firstEntryDate
                                .formatAsLocalizedDate(context),
                            constraints: constraints,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatisticsItemRow extends StatelessWidget {
  final List<Widget> children;
  const _StatisticsItemRow({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _StatisticsHeaderItem extends StatelessWidget {
  final String value;
  final String label;
  final BoxConstraints constraints;
  const _StatisticsHeaderItem({
    Key? key,
    required this.value,
    required this.label,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth / 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: LitSansSerifStyles.h6.copyWith(
                color: LitColors.lightGrey,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: LitSansSerifStyles.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}
