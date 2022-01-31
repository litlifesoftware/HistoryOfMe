part of widgets;

class SelectedCreateTile extends StatelessWidget {
  final String label;

  const SelectedCreateTile({
    Key? key,
    required this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              12.0,
            ),
            color: HexColor('#8e8e8e')),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Text(
            "$label",
            style: LitTextStyles.sansSerif.copyWith(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
