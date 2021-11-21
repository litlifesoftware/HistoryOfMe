import 'package:flutter/material.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:leitmotif/leitmotif.dart';

class QuoteCard extends StatefulWidget {
  final String? initialQuote;
  final String? initialAuthor;
  final void Function(String) onQuoteChanged;
  final void Function(String) onAuthorChanged;
  const QuoteCard({
    Key? key,
    required this.initialQuote,
    required this.initialAuthor,
    required this.onAuthorChanged,
    required this.onQuoteChanged,
  }) : super(key: key);

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final FocusNode _quoteFocus = FocusNode();
  final FocusNode _authorFocus = FocusNode();
  late TextEditingController _quoteEditingController;
  late TextEditingController _authorEditingController;

  @override
  void initState() {
    super.initState();
    _quoteEditingController = TextEditingController(
      text: widget.initialQuote,
    );
    _authorEditingController = TextEditingController(
      text: widget.initialAuthor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: LitTitledActionCard(
        title: HOMLocalizations(context).quote,
        subtitle: HOMLocalizations(context).quoteSubtitleLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 78.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: EditableText(
                  backgroundCursorColor: Colors.black,
                  cursorColor: LitColors.mediumGrey,
                  controller: _quoteEditingController,
                  maxLines: null,
                  focusNode: _quoteFocus,
                  style: LitTextStyles.sansSerif.copyWith(
                    height: 1.5,
                    letterSpacing: 0.32,
                  ),
                  onChanged: widget.onQuoteChanged,
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
                    HOMLocalizations(context).by,
                    style: LitTextStyles.sansSerif.copyWith(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: LitColors.mediumGrey.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                  EditableText(
                    backgroundCursorColor: Colors.black,
                    cursorColor: LitColors.mediumGrey,
                    maxLines: 1,
                    controller: _authorEditingController,
                    focusNode: _authorFocus,
                    style: LitTextStyles.sansSerif.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    onChanged: widget.onAuthorChanged,
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
