import 'package:flutter/material.dart';
import 'package:union/component/const/colors.dart';

class GroupTextFormField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final String? prefix;
  final Color borderColor;
  final Color focusedBorderColor;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const GroupTextFormField({
    required this.title,
    required this.onChanged,
    this.controller,
    this.autofocus = false,
    this.obscureText = false,
    this.borderColor = COLOR_GRAY_MID,
    this.focusedBorderColor = Colors.white,
    this.hintText,
    this.errorText,
    this.prefix,
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

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 17.0,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: controller,
              cursorColor: COLOR_GRAY_MID,
              autofocus: autofocus,
              onChanged: onChanged,
              obscureText: obscureText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: hintText,
                  errorText: errorText,
                  prefixText: prefix,
                  prefixStyle: const TextStyle(
                    color: COLOR_GRAY_LIGHT,
                    fontSize: 19.0,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w900,
                  ),
                  hintStyle: const TextStyle(
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
            ),
          ),
        ],
      ),
    );
  }
}
