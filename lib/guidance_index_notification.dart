import 'package:flutter/material.dart';

class GuidanceIndexNotification extends Notification {
  GuidanceIndexNotification({
    @required this.currentIndex,
  });
  final int currentIndex;
}