part of widgets;

class DiaryEntryBottomSheet extends StatelessWidget {
  final String? title;
  final void Function() onPressedEdit;
  final void Function() onPressedDelete;
  const DiaryEntryBottomSheet({
    Key? key,
    this.title,
    required this.onPressedEdit,
    required this.onPressedDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.0),
          ScrollableText(
            title ?? AppLocalizations.of(context).optionsLabel.capitalize(),
            style: LitSansSerifStyles.h6.copyWith(
              color: LitColors.grey380,
            ),
          ),
          Divider(),
          SizedBox(
            height: 142.0,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              children: [
                LitPushedThroughButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LitIcons.pencil_alt,
                        color: LitSansSerifStyles.button.color,
                        size: LitSansSerifStyles.button.fontSize,
                      ),
                      SizedBox(width: 8.0),
                      ClippedText(
                        AppLocalizations.of(context).editLabel.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: LitSansSerifStyles.button,
                      ),
                    ],
                  ),
                  accentColor: LitColors.grey100,
                  onPressed: onPressedEdit,
                ),
                SizedBox(height: 16.0),
                LitDeleteButton(
                  textAlign: TextAlign.center,
                  showIcon: true,
                  onPressed: onPressedDelete,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
