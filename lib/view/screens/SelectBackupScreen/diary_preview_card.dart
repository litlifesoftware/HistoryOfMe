import 'package:flutter/material.dart';
import 'package:history_of_me/model/models.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';

class DiaryPreviewCard extends StatelessWidget {
  final DiaryBackup diaryBackup;
  final Future Function() rebuildDatabase;
  const DiaryPreviewCard({
    Key? key,
    required this.diaryBackup,
    required this.rebuildDatabase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledActionCard(
      title: "We found your diary",
      subtitle: "Continue your journey",
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              LayoutBuilder(
                builder: (constex, constraints) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 48.0,
                        width: 48.0,
                        child: UserIcon(
                          size: 48.0,
                          userData: diaryBackup.userData,
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                        width: constraints.maxWidth - 48.0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 2.0,
                            bottom: 2.0,
                            right: 2.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                diaryBackup.userData.name + "'s diary",
                                style: LitSansSerifStyles.subtitle2,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "History of Me",
                                      style: LitSansSerifStyles.caption,
                                    ),
                                    TextSpan(
                                      text: " ${diaryBackup.appVersion}",
                                      style:
                                          LitSansSerifStyles.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              BookmarkFront(
                userData: diaryBackup.userData,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total entries: ",
                    style: LitSansSerifStyles.body2,
                  ),
                  LitBadge(
                    borderRadius: BorderRadius.circular(16.0),
                    backgroundColor: LitColors.lightGrey,
                    child: Text(
                      diaryBackup.diaryEntries.length.toString(),
                      style: LitSansSerifStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last updated: ",
                    style: LitSansSerifStyles.body2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateTime.parse(diaryBackup.backupDate)
                            .formatAsLocalizedDateTime(context),
                        style: LitSansSerifStyles.subtitle1,
                      ),
                      RelativeDateTimeBuilder.now(
                        date: DateTime.parse(diaryBackup.backupDate),
                        builder: (date, formatted) {
                          return Text(
                            formatted,
                            style: LitSansSerifStyles.caption,
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
      actionButtonData: [
        ActionButtonData(
          title: "RESTORE DIARY".toUpperCase(),
          onPressed: rebuildDatabase,
          backgroundColor: Color(0xFFC7EBD3),
          accentColor: Color(0xFFD7ECF4),
        ),
      ],
    );
  }
}
