import 'package:flutter/material.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';

void main() async {
  await HiveDBService().initHiveDB();
  runApp(App());
}
