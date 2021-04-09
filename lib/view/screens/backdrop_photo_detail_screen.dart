import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class BackdropPhotoDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      backgroundColor: Colors.black,
      appBar: LitBlurredAppBar(title: "Photo"),
      body: Center(
        child: Text(
          "SDF",
        ),
      ),
    );
  }
}
