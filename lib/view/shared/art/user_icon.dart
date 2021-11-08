import 'package:flutter/material.dart';
import 'package:history_of_me/model/models.dart';
import 'package:leitmotif/leitmotif.dart';

class UserIcon extends StatelessWidget {
  final UserData userData;
  final double size;
  final void Function()? onPressed;
  const UserIcon({
    Key? key,
    required this.size,
    required this.userData,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitUserIcon(
      size: size,
      name: userData.name,
      color: Color(userData.primaryColor),
      accentColor: Color(0xFFDDDDDD),
      onPressed: onPressed,
    );
  }
}
