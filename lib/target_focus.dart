import 'package:flutter/widgets.dart';
import 'guide_target.dart';
import './target_position.dart';
import './guidance_info.dart';

class TargetFocus {
  TargetFocus({
    this.identify,
    this.keyTarget,
    this.targetPosition,
    this.content,
    this.shape,
    this.radius,
    this.color,
    this.enableOverlayTab = false,
    this.enableTargetTab = true,
    this.contextModel
  }) : assert((keyTarget != null || targetPosition != null) && contextModel != null);

  final dynamic identify;
  final GlobalKey keyTarget;
  final TargetPosition targetPosition;
  final Guidetarget content;
  final GuidanceRectType shape;
  final double radius;
  final bool enableOverlayTab;
  final bool enableTargetTab;
  final Color color;
  final GuidanceContextInfo contextModel;
 
  @override
  String toString() {
    return 'TargetFocus{identify: $identify, keyTarget: $keyTarget, targetPosition: $targetPosition, contents: $content, shape: $shape}';
  }
}
