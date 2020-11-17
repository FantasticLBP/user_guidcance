import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'guidance_info.dart';
import 'light_painter.dart';
import 'light_rect_painter.dart';
import 'target_focus.dart';
import 'target_position.dart';
import 'guidance_index_notification.dart';
import 'util.dart';

class FocusLight extends StatefulWidget {
  final List<TargetFocus> targets;
  final Function(TargetFocus) focus;
  final Function(TargetFocus) clickTarget;
  final Function removeFocus;
  final Function() finish;
  final double paddingFocus;
  final Color colorShadow;
  final double opacityShadow;

  FocusLight({
    Key key,
    this.targets,
    this.focus,
    this.finish,
    this.removeFocus,
    this.clickTarget,
    this.paddingFocus = 0,
    this.colorShadow = Colors.black,
    this.opacityShadow = 0.8,
  }) : super(key: key);

  @override
  FocusLightState createState() => FocusLightState();
}

class FocusLightState extends State<FocusLight>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController controllerPulse;
  CurvedAnimation curvedAnimation;
  Offset positioned = Offset(0.0, 0.0);
  TargetPosition _targetPosition;

  double sizeCircle = 100;
  int currentFocus = 0;
  bool finishFocus = false;
  bool initReverse = false;
  double progressAnimated = 0;
  TargetFocus targetFocus;
  bool goNext = true;
  BuildContext currentContext;

  @override
  void initState() {
    targetFocus = widget?.targets[currentFocus];
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    );

    controllerPulse = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    controller.addStatusListener(_listener);
    controllerPulse.addStatusListener(_listenerPulse);

    WidgetsBinding.instance.addPostFrameCallback((_) => runFocus());
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return InkWell(
      onTap: targetFocus.enableOverlayTab ? next : null,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          progressAnimated = curvedAnimation.value;
          return Stack(
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: CustomPaint(
                      painter: _getPainter(
                        targetFocus,
                        ),
                    ),
                  ),
                  Positioned(
                    left: _targetPosition?.offset?.dx ,
                    top: _targetPosition?.offset?.dy ,
                    child: Container(
                      color: Colors.transparent,
                      width: _targetPosition?.size?.width,
                      height: _targetPosition?.size?.height,
                    ),
                  )
                ],
              );
        },
      ),
    );
  }

  void next() => _tapHandler();
  void previous() => _tapHandler(goNext: false);

  void _tapHandler({bool goNext = true}) {
    setState(() {
      goNext = goNext;
      initReverse = true;
    });
    controllerPulse.reverse(from: controllerPulse.value);
    widget?.clickTarget(targetFocus);
  }

  void nextFocus() {
    if (currentFocus >= widget.targets.length - 1) {
      this._finish();
      return;
    }
    currentFocus++;
    new GuidanceIndexNotification(currentIndex: currentFocus).dispatch(currentContext);
    runFocus();
  }

  void previousFocus() {
    if (currentFocus <= 0) {
      this._finish();
      return;
    }
    currentFocus--;
    new GuidanceIndexNotification(currentIndex: currentFocus).dispatch(currentContext);
    runFocus();
  }

  void runFocus() {
    if (currentFocus < 0) return;
    targetFocus = widget.targets[currentFocus];
    var targetPosition = getTargetCurrent(targetFocus);
    if (targetPosition == null) {
      this._finish();
      return;
    }

    setState(() {
      finishFocus = false;
      this._targetPosition = targetPosition;

      positioned = Offset(
        targetPosition.offset.dx + (targetPosition.size.width / 2),
        targetPosition.offset.dy + (targetPosition.size.height / 2),
      );
      sizeCircle = targetFocus.contextModel.ovalRect.width/2.0;
    });

    controller.forward();
  }

  void _finish() {
    setState(() {
      currentFocus = 0;
    });
    widget.finish();
  }

  @override
  void dispose() {
    controllerPulse.dispose();
    controller.dispose();
    super.dispose();
  }

  void _listenerPulse(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controllerPulse.reverse();
    }

    if (status == AnimationStatus.dismissed) {
      if (initReverse) {
        setState(() {
          finishFocus = false;
        });
        controller.reverse();
      } else if (finishFocus) {
        controllerPulse.forward();
      }
    }
  }

  void _listener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        finishFocus = true;
      });
      widget?.focus(targetFocus);

      controllerPulse.forward();
    }
    if (status == AnimationStatus.dismissed) {
      setState(() {
        finishFocus = false;
        initReverse = false;
      });
      if (goNext) {
        nextFocus();
      } else {
        previousFocus();
      }
    }

    if (status == AnimationStatus.reverse) {
      widget?.removeFocus();
    }
  }

  CustomPainter _getPainter(TargetFocus target, ) {
    if (target?.shape == GuidanceRectType.rectangle) {
      return LightRectPainter(
        colorShadow: target?.color ?? widget.colorShadow,
        progress: progressAnimated,
        offset: widget.paddingFocus,
        target: _targetPosition ?? TargetPosition(Size.zero, Offset.zero),
        radius: target?.radius ?? 0,
        opacityShadow: widget.opacityShadow
      );
    } else {
      return LightPainter(
        progressAnimated,
        positioned,
        sizeCircle,
        colorShadow: target?.color ?? widget.colorShadow,
        opacityShadow: widget.opacityShadow,
      );
    }
  }
}
