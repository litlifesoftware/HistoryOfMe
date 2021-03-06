import 'package:flutter/material.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/view/styles/app_colors.dart';
import 'package:leitmotif/leitmotif.dart';

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
      title: HOMLocalizations(context).createNewDiary,
      subtitle: HOMLocalizations(context).startNewJourney,
      actionButtonData: [
        ActionButtonData(
          title: HOMLocalizations(context).create,
          onPressed: onCreate,
          backgroundColor: AppColors.pastelPink,
          accentColor: AppColors.pastelPurple,
        ),
      ],
    );
  }
}
