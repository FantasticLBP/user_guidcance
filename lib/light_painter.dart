import 'package:flutter/material.dart';

class LightPainter extends CustomPainter {
  final double progress;
  final Offset positioned;
  final double sizeCircle;
  final Color colorShadow;
  final double opacityShadow;

  Paint _paintFocus;

  LightPainter(
    this.progress,
    this.positioned,
    this.sizeCircle, {
    this.colorShadow = Colors.black,
    this.opacityShadow = 0.8,
  }) : assert(opacityShadow >= 0 && opacityShadow <= 1) {
    _paintFocus = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawColor(colorShadow.withOpacity(opacityShadow), BlendMode.dstATop);

    var maxSize = size.width > size.height ? size.width : size.height;
    // 半径计算规则
    double radius = maxSize * (1 - progress) + sizeCircle;

    canvas.drawCircle(positioned, radius, _paintFocus);
    canvas.restore();
  }

  @override
  bool shouldRepaint(LightPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}