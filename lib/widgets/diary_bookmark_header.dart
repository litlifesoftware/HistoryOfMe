part of widgets;

class DiaryBookmarkHeader extends StatelessWidget {
  final UserData userData;
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
                    BookmarkPageView(
                      animationController: bookmarkAnimation,
                      userData: userData,
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
