import 'package:flutter/material.dart';
import 'package:leitmotif/leitmotif.dart';

class CreateNewActionCard extends StatelessWidget {
  final void Function() onCreate;
  const CreateNewActionCard({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "Create a new diary",
      subtitle: "Start a new journey",
      actionButtonData: [
        ActionButtonData(
          title: "Create new diary",
          onPressed: onCreate,
          backgroundColor: Color(0xFFEBC7CF),
          accentColor: Color(0xFFDFD7F4),
        ),
      ],
    );
  }
}
