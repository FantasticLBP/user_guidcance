import 'package:flutter/material.dart';
import 'target_focus.dart';
import 'guidance_info.dart';
import 'guide_target.dart';
import 'guidance_view.dart';
import 'guidance_starter_widget.dart';


class UserGuidance {
  final List<GuidanceContextInfo> contextModels;
  final BuildContext _context;
  final Function(TargetFocus) onClickTarget;
  final Function() onFinish;
  final double paddingFocus;
  final Function() onClickSkip;
  final AlignmentGeometry alignSkip;
  final String textSkip;
  final TextStyle textStyleSkip;
  final bool hideSkip;
  final Color colorShadow;
  final double opacityShadow;
  final GlobalKey<GuidanceStarterWidgetState> _widgetKey = GlobalKey();

  OverlayEntry _overlayEntry;

  get targets {
    List<TargetFocus> targets = List();
    for (var i = 0; i < contextModels.length; i++) {
      GuidanceContextInfo contextModel = contextModels.elementAt(i);
      targets.add(
        TargetFocus(
            identify: "Target $i",
            keyTarget: contextModel.elementKey,
            contextModel: contextModel,
            shape: contextModel.rectType,
            content: Guidetarget(
                child: GuidanceView(
                    contextModel: contextModel, 
                    handleNextStep: next
                )
              )
            ),
      );
    }
    return targets;
  }

  UserGuidance(
    this._context, {
    this.contextModels,
    this.colorShadow = Colors.black,
    this.onClickTarget,
    this.onFinish,
    this.paddingFocus = 0,
    this.onClickSkip,
    this.alignSkip = Alignment.bottomRight,
    this.textSkip = "跳过",
    this.textStyleSkip = const TextStyle(color: Colors.white),
    this.hideSkip = true,
    this.opacityShadow = 0.8,
  }) : assert(opacityShadow >= 0 && opacityShadow <= 1);

  OverlayEntry _buildOverlay() {
    return OverlayEntry(builder: (context) {
      return GuidanceStarterWidget(
        targets: targets,
        handleNextStep: next,
        key: _widgetKey,
        clickTarget: onClickTarget,
        paddingFocus: paddingFocus,
        clickSkip: skip,
        alignSkip: alignSkip,
        textSkip: textSkip,
        textStyleSkip: textStyleSkip,
        hideSkip: hideSkip,
        colorShadow: colorShadow,
        opacityShadow: opacityShadow,
        finish: finish,
      );
    });
  }

  void show() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlay();
      Overlay.of(_context).insert(_overlayEntry);
    }
  }

  void finish() {
    if (onFinish != null) onFinish();
    _removeOverlay();
  }

  void skip() {
    if (onClickSkip != null) onClickSkip();
    _removeOverlay();
  }

  void next() {
    _widgetKey?.currentState?.next();
  }

  void previous() => _widgetKey?.currentState?.previous();

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
