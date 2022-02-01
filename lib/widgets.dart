/// Widgets implementing various user interface components of History of me.
///
/// To use, import `package:history_of_me/widgets.dart`.
library widgets;

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/controller/backdrop_photo_controller.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/controller/mood_translation_controller.dart';
import 'package:history_of_me/extensions.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/screens.dart';
import 'package:history_of_me/styles.dart';
import 'package:history_of_me/view/shared/bookmark/bookmark_page_view.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:lit_backup_service/lit_backup_service.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'widgets/backdrop_photo_overlay.dart';
part 'widgets/cancel_restoring_dialog.dart';
part 'widgets/change_name_dialog.dart';
part 'widgets/change_photo_dialog.dart';
part 'widgets/clean_text_field.dart';
part 'widgets/create_entry_dialog.dart';
part 'widgets/deletable_container.dart';
part 'widgets/diary_backup_dialog.dart';
part 'widgets/diary_bookmark_header.dart';
part 'widgets/diary_filter_header.dart';
part 'widgets/diary_filter_header_delegate.dart';
part 'widgets/diary_list_tile.dart';
part 'widgets/diary_list_view.dart';
part 'widgets/diary_preview_card.dart';
part 'widgets/entry_day_selection_tile.dart';
part 'widgets/entry_detail_backdrop.dart';
part 'widgets/entry_detail_card.dart';
part 'widgets/greetings_bar.dart';
part 'widgets/pattern_config_card.dart';
part 'widgets/primary_color_selector_card.dart';
part 'widgets/quote_card.dart';
part 'widgets/secondary_color_selector_card.dart';
part 'widgets/selectable_color_tile.dart';
part 'widgets/selected_create_tile.dart';
part 'widgets/settings_footer.dart';
part 'widgets/statistics_card.dart';
part 'widgets/unselected_create_tile.dart';
part 'widgets/user_profile_card.dart';
part 'widgets/word_count_badge.dart';
