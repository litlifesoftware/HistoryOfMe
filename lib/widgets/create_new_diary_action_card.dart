part of widgets;

/// A Flutter widget displaying an action card to allow the user to create a
/// new diary.
class CreateNewActionCard extends StatelessWidget {
  /// Handles the `create` action.
  final void Function() onCreate;

  /// Creates a [CreateNewActionCard].
  const CreateNewActionCard({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: AppLocalizations.of(context).newDiaryTitle,
      subtitle: AppLocalizations.of(context).startJourneyTitle,
      actionButtonData: [
        ActionButtonData(
          title: AppLocalizations.of(context).createLabel,
          onPressed: onCreate,
          backgroundColor: AppColors.pastelPink,
          accentColor: AppColors.pastelPurple,
        ),
      ],
    );
  }
}
