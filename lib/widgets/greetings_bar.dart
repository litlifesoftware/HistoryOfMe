part of widgets;

class GreetingsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Scaffold.of(context).appBarMaxHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            offset: Offset(2, 4),
            color: Colors.black,
            spreadRadius: 2.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: Text(
          AppLocalizations.of(context).greetingLabel,
          textAlign: TextAlign.center,
          style: LitSansSerifStyles.subtitle2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
