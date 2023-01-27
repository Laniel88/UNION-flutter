import 'package:flutter/material.dart';

class EmptySpace extends StatelessWidget {
  final double size;
  const EmptySpace({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.width) * size,
    );
  }
}
