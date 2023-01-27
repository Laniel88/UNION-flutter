import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rive/rive.dart';
import 'package:union/component/const/colors.dart';

const riveAsset = 'asset/rive/checkerror.riv';

class CheckErrorScreen extends StatefulWidget {
  final Widget route;
  final bool sucess;
  final Color backgroundColor;
  const CheckErrorScreen({
    required this.route,
    required this.backgroundColor,
    required this.sucess,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckErrorScreen> createState() => _CheckErrorScreenState();
}

class _CheckErrorScreenState extends State<CheckErrorScreen> {
  bool darkTheme = false;
  Artboard? _artboard;

  SMITrigger? _check;
  SMITrigger? _error;
  SMITrigger? _reset;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
    // TODO : Dummy (manual delay function)
    animationDelayed(500, widget.sucess);
  }

  void animationDelayed(int milliseconds, bool sucess) {
    if (sucess) {
      Future.delayed(Duration(milliseconds: milliseconds), () {
        _hitCheck();
      });
      Future.delayed(Duration(milliseconds: milliseconds + 2000), () {
        Navigator.of(context).pushAndRemoveUntil(
          PageTransition(
            child: widget.route,
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 400),
          ),
          (route) => false,
        );
      });
    } else {
      Future.delayed(Duration(milliseconds: milliseconds), () {
        _hitError();
      });
      Future.delayed(Duration(milliseconds: milliseconds + 2000), () {
        Navigator.of(context).pop();
      });
    }
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveAsset);

    RiveFile rFile = RiveFile.import(bytes);

    setState(() => _artboard = rFile.mainArtboard);

    final controller =
        StateMachineController.fromArtboard(_artboard!, 'State Machine 1');
    _artboard!.addController(controller!);
    _reset = controller.findInput<bool>('Reset') as SMITrigger;
    _check = controller.findInput<bool>('Check') as SMITrigger;
    _error = controller.findInput<bool>('Error') as SMITrigger;
    _hitReset();
  }

  void _hitCheck() => _check?.fire();
  void _hitError() => _error?.fire();
  void _hitReset() => _reset?.fire();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      body: Center(
        child: _artboard != null
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 4,
                child: Rive(
                  useArtboardSize: true,
                  artboard: _artboard!,
                ),
              )
            : Container(),
      ),
    );
  }
}
