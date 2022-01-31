part of widgets;

class UnselectedCreateTile extends StatelessWidget {
  final String? label;

  const UnselectedCreateTile({Key? key, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      child: Text(
        "$label",
        style: LitTextStyles.sansSerif.copyWith(
          fontSize: 16.0,
          color: LitColors.darkGrey,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
