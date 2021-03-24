import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class GreetingsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Scaffold.of(context).appBarMaxHeight,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 8.0,
          offset: Offset(2, 4),
          color: Colors.black,
          spreadRadius: 2.0,
        )
      ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: Text(
          "How are you today?",
          textAlign: TextAlign.center,
          style: LitTextStyles.sansSerif.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
