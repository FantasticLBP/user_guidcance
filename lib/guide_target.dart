import 'package:flutter/widgets.dart';
import 'custom_target_position.dart';

enum AlignContent { top, bottom, left, right, custom }

class Guidetarget {
  Guidetarget({
    this.align = AlignContent.bottom,
    this.child,
    this.customPosition,
  }) : assert(child != null &&
            !(align == AlignContent.custom && customPosition == null));

  final AlignContent align;
  final CustomTargetPosition customPosition;
  final Widget child;
  @override
  String toString() {
    return 'Guidetarget{align: $align, child: $child}';
  }
}
