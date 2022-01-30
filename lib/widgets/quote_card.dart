part of widgets;

class QuoteCard extends StatefulWidget {
  final TextEditingController authorController;
  final TextEditingController quoteController;
  const QuoteCard({
    Key? key,
    required this.authorController,
    required this.quoteController,
  }) : super(key: key);

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final FocusNode _quoteFocus = FocusNode();
  final FocusNode _authorFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: LitTitledActionCard(
        title: AppLocalizations.of(context).quoteLabel.capitalize(),
        subtitle: AppLocalizations.of(context).quoteSubtitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 78.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: CleanTextField(
                  focusNode: _quoteFocus,
                  style: LitTextStyles.sansSerif.copyWith(
                    height: 1.5,
                    letterSpacing: 0.32,
                  ),
                  controller: widget.quoteController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).byLabel,
                    style: LitTextStyles.sansSerif.copyWith(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: LitColors.mediumGrey.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                  CleanTextField(
                    controller: widget.authorController,
                    focusNode: _authorFocus,
                    style: LitTextStyles.sansSerif.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
