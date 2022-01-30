/// Widgets implementing various user interface components of History of me.
///
/// To use, import `package:history_of_me/widgets.dart`.
library widgets;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/extensions.dart';
import 'package:history_of_me/models.dart';

import 'package:leitmotif/leitmotif.dart';

part 'view/widgets/clean_text_field.dart';
part 'view/widgets/word_count_badge.dart';
part 'widgets/deletable_container.dart';
part 'widgets/pattern_config_card.dart';
part 'widgets/primary_color_selector_card.dart';
part 'widgets/quote_card.dart';
part 'widgets/secondary_color_selector_card.dart';
part 'widgets/selectable_color_tile.dart';
