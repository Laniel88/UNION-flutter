import 'package:flutter/material.dart';

class LogoFull extends StatelessWidget {
  final double imgSize;
  final double spaceBtw;
  final double fontSize;

  const LogoFull(
      {this.imgSize = 25, this.spaceBtw = 3, this.fontSize = 8, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: (MediaQuery.of(context).size.width) / 100 * imgSize,
            child: Image.asset(
              'asset/img/UNION_logo.jpeg',
            )),
        SizedBox(
          height: spaceBtw,
        ),
        Text(
          'UNI-ON',
          style: TextStyle(
            color: Colors.white,
            fontSize: (MediaQuery.of(context).size.width) / 100 * fontSize,
            fontFamily: 'Kodchasan',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class LogoImg extends StatelessWidget {
  final int size;
  const LogoImg({required this.size, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width) / 100 * size,
      child: Image.asset('asset/img/UNION_logo.jpeg'),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
