import 'package:flutter/material.dart';
import 'package:union/component/const/colors.dart';

class LoginTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final Color borderColor;
  final Color focusedBorderColor;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const LoginTextFormField({
    required this.onChanged,
    this.controller,
    this.autofocus = false,
    this.obscureText = false,
    this.borderColor = COLOR_GRAY_MID,
    this.focusedBorderColor = Colors.white,
    this.hintText,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: 1.0,
      ),
    ); // UnderlineInputBorder

    return TextFormField(
      controller: controller,
      cursorColor: COLOR_GRAY_MID,
      autofocus: autofocus,
      onChanged: onChanged,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(18),
          hintText: hintText,
          errorText: errorText,
          hintStyle: TextStyle(
            color: COLOR_GRAY_LIGHT,
            fontSize: 15.0,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
          ),
          filled: false,
          focusColor: Colors.white,
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(
            color: focusedBorderColor,
          ))),
    );
  }
}
