import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitSignUpScreen extends StatefulWidget {
  final String title;
  final void Function() onSubmit;
  final bool showUsernameInput;
  final bool showPasswordInput;
  final bool showPasswordConfirmInput;
  final bool showPinInput;
  final String usernameLabel;
  final String passwordLabel;
  final String passwordConfirmLabel;
  final String pinLabel;
  final String onSubmitButtonText;
  final void Function(String)? onUsernameChange;
  final void Function(String)? onPasswordChange;
  final void Function(String)? onPasswordConfirmChange;
  final void Function(int?)? onPINChange;
  const LitSignUpScreen({
    Key? key,
    this.title = 'Sign up',
    required this.onSubmit,
    this.showUsernameInput = true,
    this.showPasswordInput = true,
    this.showPasswordConfirmInput = true,
    this.showPinInput = true,
    this.usernameLabel = 'Username',
    this.passwordLabel = 'Password',
    this.passwordConfirmLabel = 'Confirm Password',
    this.pinLabel = 'PIN',
    this.onSubmitButtonText = 'Submit',
    this.onUsernameChange,
    this.onPasswordChange,
    this.onPasswordConfirmChange,
    this.onPINChange,
  }) : super(key: key);
  @override
  _LitSignUpScreenState createState() => _LitSignUpScreenState();
}

class _LitSignUpScreenState extends State<LitSignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();
  final FocusNode _pinFocus = FocusNode();
  late AnimationController _animationController;

  String get _usernameText {
    return _usernameController.value.text;
  }

  String get _passwordText {
    return _passwordController.value.text;
  }

  String get _passwordConfirmText {
    return _passwordConfirmController.value.text;
  }

  int? get _pinValue {
    return int.tryParse(_pinController.value.text);
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 3000,
      ),
    );
    _animationController.repeat(reverse: true);
    if (widget.onUsernameChange != null) {
      _usernameController.addListener(() {
        widget.onUsernameChange!(_usernameText);
      });
    }
    if (widget.onPasswordChange != null) {
      _passwordController.addListener(() {
        widget.onPasswordChange!(_passwordText);
      });
    }
    if (widget.onPasswordConfirmChange != null) {
      _passwordConfirmController.addListener(() {
        widget.onPasswordConfirmChange!(_passwordConfirmText);
      });
    }
    if (widget.onPINChange != null) {
      _pinController.addListener(() {
        widget.onPINChange!(_pinValue);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: _unfocus,
              child: LitAnimatedGradientBackground(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return Transform.rotate(
                    angle:
                        (pi / 180) * (-30 + (-5 * _animationController.value)),
                    child: Transform(
                      transform: Matrix4.translationValues(
                          15.0 + (15.0 * _animationController.value),
                          -115.0 + (-10 * _animationController.value),
                          0.0),
                      child: SizedBox(
                        height: 300.0,
                        width: 500.0,
                        child: LitGradientCard(
                          begin: Alignment.bottomRight,
                          end: Alignment.bottomLeft,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12.0,
                              color: Colors.black12,
                              offset: Offset(
                                _animationController.value * -8,
                                _animationController.value * 2,
                              ),
                              spreadRadius: _animationController.value * 3.0,
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(
                              80.0,
                            ),
                            bottomLeft: Radius.circular(
                              128.0,
                            ),
                            topLeft: Radius.circular(
                              80.0,
                            ),
                            topRight: Radius.circular(
                              80.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 30.0,
                ),
                child: Container(
                  height: 220.0,
                  width: 220.0,
                  child: ClippedText(
                    widget.title,
                    maxLines: 3,
                    style: LitTextStyles.sansSerif.copyWith(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: HexColor('#979797'),
                        letterSpacing: 0.25),
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  top: 100.0,
                  bottom: 80.0,
                ),
                physics: BouncingScrollPhysics(),
                child: InkWell(
                  onTap: _unfocus,
                  child: LitGradientCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30.0,
                        horizontal: 15.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              widget.showUsernameInput
                                  ? _InputArea(
                                      textEditingController:
                                          _usernameController,
                                      focusNode: _usernameFocus,
                                      label: widget.usernameLabel,
                                    )
                                  : SizedBox(),
                              widget.showPasswordInput
                                  ? _InputArea(
                                      textEditingController:
                                          _passwordController,
                                      focusNode: _passwordFocus,
                                      label: widget.passwordLabel,
                                    )
                                  : SizedBox(),
                              widget.showPasswordConfirmInput
                                  ? _InputArea(
                                      textEditingController:
                                          _passwordConfirmController,
                                      focusNode: _passwordConfirmFocus,
                                      label: widget.passwordConfirmLabel,
                                    )
                                  : SizedBox(),
                              widget.showPinInput
                                  ? _InputArea(
                                      textEditingController: _pinController,
                                      focusNode: _pinFocus,
                                      label: widget.pinLabel,
                                    )
                                  : SizedBox(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: LitGradientButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 8.0,
                    ),
                    boxShadow: const [
                      const BoxShadow(
                        blurRadius: 8.0,
                        offset: Offset(-1.5, 2.0),
                        color: Colors.black26,
                        spreadRadius: 1.0,
                      )
                    ],
                    child: Text(widget.onSubmitButtonText,
                        style: LitTextStyles.sansSerif.copyWith(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w700,
                          color: HexColor('#8A8A8A'),
                          letterSpacing: 0.65,
                        )),
                    onPressed: widget.onSubmit,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class _InputArea extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String label;
  final bool initialObsureTextValue;
  final bool allowObscuredText;
  const _InputArea({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.label,
    this.initialObsureTextValue = false,
    this.allowObscuredText = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Column(
        children: [
          Text(
            "$label".toUpperCase(),
            style: LitTextStyles.sansSerif.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: HexColor('#A9A8A8'),
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          EditableText(
            cursorColor: Colors.grey,
            backgroundCursorColor: Colors.black,
            controller: textEditingController,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            cursorRadius: Radius.circular(2.0),
            style: LitTextStyles.sansSerif.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: HexColor('#444444'),
                letterSpacing: 1.25),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 24.0,
            ),
            child: Container(
              height: 4.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    HexColor('#ECECEC'),
                    HexColor('#C9C9C9'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
