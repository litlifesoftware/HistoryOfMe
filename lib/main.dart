import 'package:flutter/material.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/api.dart';

void main() async {
  await AppAPI().init();
  runApp(App());
}
