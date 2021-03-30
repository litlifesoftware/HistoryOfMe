import 'package:flutter/material.dart';
import 'package:history_of_me/controller/striped_design_controller.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/shared/bookmark/bookmark_design.dart';

class StripedDesign extends StatelessWidget implements BookmarkDesign {
  final double radius;
  final UserData? userData;
  const StripedDesign({
    Key? key,
    required this.radius,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: Stack(
        children: [
          Column(
            children: StripedDesignController(
              radius: radius,
              color: Color(userData!.bookmarkColor!),
              count: userData!.stripeCount,
            ).stripes,
          ),
        ],
      ),
    );
  }
}
