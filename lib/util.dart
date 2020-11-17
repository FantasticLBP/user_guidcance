import 'package:flutter/widgets.dart';
import 'target_focus.dart';
import 'target_position.dart';

TargetPosition getTargetCurrent(TargetFocus target) {
  if (target.keyTarget != null) {
    var key = target.keyTarget;

    try {
      final RenderBox renderBoxRed = key.currentContext.findRenderObject();
      final size = renderBoxRed.size;
      final offset = renderBoxRed.localToGlobal(Offset.zero);

      return TargetPosition(size, offset);
    } catch (e) {
      print("ERROR:" + e.toString());
      return null;
    }
  } else {
    return target.targetPosition;
  }
}

Rect calcuateElementFrmae (GlobalKey elementKey) {
    if (elementKey == null) {
      assert(elementKey != null, '元素的 GlobalKey 必须存在');
      return Rect.zero;
    }
    RenderBox element = elementKey.currentContext.findRenderObject();
    Size size = element.size;
    Offset position = element.localToGlobal(Offset(0, 0));
    Rect rect = Rect.fromLTRB(position.dx, position.dy, position.dx + size.width, position.dy + size.height);
    return rect;
  }


