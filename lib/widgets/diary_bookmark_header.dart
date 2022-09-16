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
                      padding: const EdgeInsets.only(
                        top: 0,
                        bottom: 32.0,
                        left: 16.0,
                        right: 16.0,
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
