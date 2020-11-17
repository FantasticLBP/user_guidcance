import 'package:flutter/material.dart';
import 'focus_light.dart';
import 'target_focus.dart';
import 'guide_target.dart';
import 'guidance_index_notification.dart';
import 'guidance_info.dart';

class GuidanceStarterWidget extends StatefulWidget {
  const GuidanceStarterWidget({
    Key key,
    this.targets,
    this.finish,
    this.paddingFocus = 0,
    this.clickTarget,
    this.alignSkip = Alignment.bottomRight,
    this.textSkip = "跳过",
    this.clickSkip,
    this.colorShadow = Colors.black,
    this.opacityShadow = 0.8,
    this.textStyleSkip = const TextStyle(color: Colors.white),
    this.hideSkip, 
    this.handleNextStep,
  }) : super(key: key);
  
  final List<TargetFocus> targets;
  final Function(TargetFocus) clickTarget;
  final Function() finish;
  final Color colorShadow;
  final double opacityShadow;
  final double paddingFocus;
  final Function() clickSkip;
  final AlignmentGeometry alignSkip;
  final String textSkip;
  final TextStyle textStyleSkip;
  final bool hideSkip;
  final Function() handleNextStep;
  @override
  GuidanceStarterWidgetState createState() => GuidanceStarterWidgetState();
}

class GuidanceStarterWidgetState extends State<GuidanceStarterWidget> {
  final GlobalKey<FocusLightState> _focusLightKey = GlobalKey();
  bool showContent = false;
  TargetFocus currentTarget;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: NotificationListener<GuidanceIndexNotification>(
        onNotification: (notification) {
          currentIndex = notification.currentIndex;
          return true;
        },
        child: Stack(
          children: <Widget>[
            FocusLight(
              key: _focusLightKey,
              targets: widget.targets,
              finish: widget.finish,
              paddingFocus: widget.paddingFocus,
              colorShadow: widget.colorShadow,
              opacityShadow: widget.opacityShadow,
              clickTarget: (target) {
                if (widget.clickTarget != null) widget.clickTarget(target);
              },
              focus: (target) {
                setState(() {
                  currentTarget = target;
                  showContent = true;
                });
              },
              removeFocus: () {
                setState(() {
                  showContent = false;
                });
              },
            ),
            AnimatedOpacity(
              opacity: showContent ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: _buildContents(),
            ),
            _buildSkip()
          ],
        ), 
      )
    );
  }

  Widget _buildContents() {
    if (currentTarget == null) {
      return SizedBox.shrink();
    }

    List<Widget> children = List();
    // 计算 frame
    Guidetarget target1 = currentTarget.content;
    TargetFocus targetFocus = widget.targets.elementAt(currentIndex);
    double top = 0;
    if ((targetFocus.contextModel.position == GuidancePosition.topLeft)|| (targetFocus.contextModel.position == GuidancePosition.topRight)) {
      top = targetFocus.contextModel.arrowRect.top;
    } else {
      top = targetFocus.contextModel.arrowRect.top - targetFocus.contextModel.contentRect.height;
    }
    
    children = [
        Positioned(
          top: top,
          bottom: 0,
          left: 0,
          child: Container(
            width: targetFocus.contextModel.screenWidth,
            child: target1.child,
          ),
        )
      ];

    return Stack(
      children: children,
    );
  }

  Widget _buildSkip() {
    if (widget.hideSkip) {
      return SizedBox.shrink();
    }
    return Align(
      alignment: widget.alignSkip,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: showContent ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: InkWell(
            onTap: widget.clickSkip,
            child: Text(
                widget.textSkip,
                style: widget.textStyleSkip,
              ),
          ),
        ),
      ),
    );
  }

  void next() => _focusLightKey?.currentState?.next();
  void previous() => _focusLightKey?.currentState?.previous();
}
