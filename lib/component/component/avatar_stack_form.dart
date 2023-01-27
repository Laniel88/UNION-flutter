import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';

class AvatarStackForm extends StatelessWidget {
  final Color borderColor;
  final Color infoColor;
  final List<ImageProvider<Object>> avatars;
  final double width;

  const AvatarStackForm({
    required this.borderColor,
    required this.infoColor,
    required this.avatars,
    required this.width,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final settings = RestrictedAmountPositions(
        // maxAmountItems: 5,
        maxCoverage: 0.4,
        minCoverage: 0.4,
        align: StackAlign.left,
        laying: StackLaying.last);
    return SizedBox(
      width: width,
      child: AvatarStack(
        borderColor: borderColor,
        borderWidth: 0,
        height: 10,
        settings: settings,
        avatars: avatars,
        infoWidgetBuilder: ((surplus) => _infoWidget(surplus, context)),
      ),
    );
  }

  Widget _infoWidget(int surplus, BuildContext context) {
    return BorderedCircleAvatar(
        border: BorderSide(color: borderColor, width: 0.0),
        backgroundColor: infoColor,
        child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '+$surplus',
                style: const TextStyle(
                    color: Colors.grey, fontFamily: 'RobotoMono', fontSize: 15),
              ),
            )));
  }
}
