import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class AnimatedGradientBackground extends StatefulWidget {
  @override
  _AnimatedGradientBackgroundState createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return BluredBackgroundContainer(
            blurRadius: 4.0,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                          _animationController.value * 0.33,
                          1 - (_animationController.value * 0.4),
                        ],
                        colors: [
                          Colors.orange.withOpacity(
                            0.05 + (_animationController.value * 0.15),
                          ),
                          Colors.green.withOpacity(
                            0.20 + (_animationController.value * 0.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [
                          _animationController.value * 0.25,
                          1 - (_animationController.value * 0.35),
                        ],
                        colors: [
                          Colors.pink.withOpacity(
                            0.15 + (_animationController.value * 0.15),
                          ),
                          Colors.blue.withOpacity(
                            0.05 + (_animationController.value * 0.30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.bottomLeft,
                        colors: [
                          Colors.black38.withOpacity(
                            0.05 + (_animationController.value * 0.1),
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        colors: [
                          Colors.white54.withOpacity(
                            0.05 + (_animationController.value * 0.1),
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
