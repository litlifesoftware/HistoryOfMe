import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/shared/bookmark_front_preview.dart';

class DiaryBookmarkHeader extends StatelessWidget {
  final UserData? userData;
  final AnimationController bookmarkAnimation;
  const DiaryBookmarkHeader({
    Key? key,
    required this.userData,
    required this.bookmarkAnimation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 4.0,
                        ),
                        child: BookmarkFrontPreview(
                          animationController: bookmarkAnimation,
                          userData: userData,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
        childCount: 1,
      ),
    );
  }
}
