import 'dart:math';
import 'package:flutter/material.dart';
import 'package:user_guidcance/util.dart';

class CurvePoint {
  ///x,y 指定指引位置 从0-1 ，手机屏幕左上角开始为（0，0）位置，右下角为(1,1)
  double x;
  double y;

  ///要指示的区域透明
  double eWidth;
  double eHeight;

  ///为引导框内显示的文字
  String tipsMessage;
  String nextString;

  ///为true时显示指引的矩形
  bool isShowReact;

  CurvePoint(this.x, this.y,
      {this.tipsMessage = "--", this.nextString = "下一步",this.eWidth=0, this.eHeight=0,this.isShowReact=false});
}

enum GuidanceRectType {
  circle,
  rectangle
}

enum GuidancePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight
}

class GuidanceContextInfo {
  String title;
  String context;
  String buttonText;
  GuidanceRectType rectType;
  // Rect ovalRect;
  GlobalKey ovalKey;
  Rect dialogViewRect;
  BuildContext clipContext;
  String message;
  GlobalKey elementKey;
  Rect contentRect;

  // pad 324 phone 290
  double contextWidth = 290;
  double arrowWidth = 30;
  double arrowHeight = 70;
  double contextSeporotar = 16;
  double buttonWidth = 128;

  get ovalRect {
    return calcuateElementFrmae(ovalKey);
  }

  get arrowSeporotar {
    double arrowSeporotar = 7;
    if (rectType == GuidanceRectType.circle) {
      arrowSeporotar = -getCircleArrowSeparatorWithRadius(ovalRect.width/2.0);
    }
    return arrowSeporotar;
  }

  GuidanceContextInfo({
    this.title, 
    this.context, 
    // this.ovalRect, 
    this.ovalKey,
    this.clipContext, 
    this.elementKey, 
    this.buttonText = "下一步", 
    this.rectType = GuidanceRectType.rectangle
    }) : assert(elementKey != null || ovalKey != null);

  double getCircleArrowSeparatorWithRadius (double radius) {
    double separator = sqrt(pow(radius, 2)*2)- radius -16;
    double radiusSeparator = (sqrt(pow(radius, 2)*2) - radius) / 2.0;
    if (separator < radiusSeparator) {
        separator = radiusSeparator;
    }
    double arrowSeparator = sqrt(pow(separator, 2) / 2.0);
    return arrowSeparator;
  }

  Image fetchImageFromAssets (String imageName) {
    Image image;
    if (imageName.isEmpty) {
      assert(imageName.isNotEmpty, '图片名称不能为空');
      return image;
    }
    image = Image.asset(
      'assets/images/$imageName.png',
      package: 'user_guidcance'
    );
    return image;
  }

  get screenWidth {
    return MediaQuery.of(clipContext).size.width;
  }

  get screenHeight {
    return MediaQuery.of(clipContext).size.height;
  }
  
  get arrowImage {
    Image image;
    GuidancePosition position = this.position;
    switch (position) {
      case GuidancePosition.topLeft:
        image = fetchImageFromAssets('guideArrowUpLeft');
        break;
      case GuidancePosition.topRight:
        image = fetchImageFromAssets('guideArrowUpRight');
        break;
      case GuidancePosition.bottomLeft:
        image = fetchImageFromAssets('guideArrowDownLeft');
        break;
      case GuidancePosition.bottomRight:
        image = fetchImageFromAssets('guideArrowDownRight');
        break;
      default:
        image = fetchImageFromAssets('guideArrowUpLeft');
    }
    return image;
  }

  get position {
    GuidancePosition position = GuidancePosition.topRight;
    // 水平方方向是否在左半区
    final bool isLeftPosition = ovalRect.left + ovalRect.width/2.0 <= screenWidth/2.0;
    // 竖直方向是否落在上半区
    final bool isTopPosition = ovalRect.top + ovalRect.height/2.0 <= screenHeight/2.0;
    
    if (isLeftPosition && isTopPosition) { // 左上角
      position = GuidancePosition.topLeft;
    } else if (!isLeftPosition && isTopPosition) { // 右上角
      position = GuidancePosition.topRight;
    } else if (isLeftPosition && !isTopPosition) { // 左下角
     position = GuidancePosition.bottomLeft;
    } else if (!isLeftPosition && !isTopPosition) { // 右下角
     position = GuidancePosition.bottomRight;
    }
    return position;
  }

  double getViewHeight(String titile, String context) {
    double height = 0;
    if (title != null && title.isNotEmpty) {
      if (title.length > 0) {
        height += 24;
      }
    }
    if (context != null && context.isNotEmpty) {
      if (context.length > 0) {
        height += 8;
        height += calculateTextHeight(context, 16.0, FontWeight.normal, contextWidth, 2); 
      }
    }
    height += 16;
    height += 40;
    return height;
  }

  double calculateTextHeight(String value, double fontSize, FontWeight fontWeight, double maxWidth, int maxLines) {
    TextPainter painter = TextPainter(
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    return painter.height;
  }

  get arrowRect {
    // 计算高度
    double contextHeight = getViewHeight(title, context); 
    Rect arrowRect;
    Rect contentRect;
    GuidancePosition position = this.position;
    if (position == GuidancePosition.topLeft) {

      if ((ovalRect.left + ovalRect.width + arrowWidth - contextWidth/2.0 + contextWidth) > this.screenWidth) {
        double arrowSeporotar = 16;
        arrowRect = Rect.fromLTWH(ovalRect.left +  ovalRect.width/2.0 - arrowWidth/2.0, ovalRect.top + ovalRect.height + arrowSeporotar, arrowWidth, arrowHeight);
        contentRect = Rect.fromLTWH(ovalRect.left + ovalRect.width/2.0 - contextWidth/2.0, arrowRect.top + arrowHeight + contextSeporotar, contextWidth, contextHeight);
      } else {
        arrowRect = Rect.fromLTWH(ovalRect.left +  ovalRect.width + arrowSeporotar, ovalRect.top + ovalRect.height + arrowSeporotar, arrowWidth, arrowHeight);
        contentRect = Rect.fromLTWH(arrowRect.left + arrowWidth/2.0 - buttonWidth/2.0, arrowRect.top + arrowHeight + contextSeporotar, contextWidth, contextHeight);
      }
    } else if (position == GuidancePosition.topRight) {
      arrowRect = Rect.fromLTWH(ovalRect.left - arrowWidth - arrowSeporotar, ovalRect.top + ovalRect.height + arrowSeporotar, arrowWidth, arrowHeight);
      contentRect = Rect.fromLTWH(arrowRect.left + arrowWidth/2.0 - buttonWidth/2.0 - contextWidth, arrowRect.top + arrowHeight + contextSeporotar, contextWidth, contextHeight);
    } else if (position == GuidancePosition.bottomLeft) {
      if (ovalRect.left + ovalRect.width + arrowWidth - contextWidth/2.0 + contextWidth > this.screenWidth) {
        arrowRect = Rect.fromLTWH(ovalRect.left + ovalRect.width/2.0 - arrowWidth/2.0, ovalRect.top - arrowSeporotar - arrowHeight, arrowWidth, arrowHeight);
        contentRect = Rect.fromLTWH(ovalRect.left + ovalRect.width/2.0 - contextWidth/2.0, arrowRect.top - contextSeporotar - contextHeight, contextWidth, contextHeight);
      } else {
        arrowRect = Rect.fromLTWH(ovalRect.left + ovalRect.width + arrowSeporotar, ovalRect.top - arrowSeporotar - arrowHeight - 16, arrowWidth, arrowHeight);
        contentRect = Rect.fromLTWH(arrowRect.left + arrowWidth/2.0 - buttonWidth/2.0, arrowRect.top - contextSeporotar - contextHeight, contextWidth, contextHeight);
      }
    } else if (position == GuidancePosition.bottomRight) {
      arrowRect = Rect.fromLTWH(ovalRect.left - arrowWidth - arrowSeporotar, ovalRect.top - arrowSeporotar - arrowHeight - 16, arrowWidth, arrowHeight);
      contentRect = Rect.fromLTWH(arrowRect.left + arrowWidth/2.0  + buttonWidth/2.0 - contextWidth, arrowRect.top - contextSeporotar - contextHeight, contextWidth, contextHeight);
    }
    this.contentRect = contentRect;
    return arrowRect;
  }
}

class GlobalKeyPoint {

  ///widget 对应key 程序自动判断
  GlobalKey key;

  ///为引导框内显示的文字
  String tipsMessage;
  String nextString;
  ///为true时显示指引的矩形
  bool isShowReact;

  GlobalKeyPoint(this.key,
      {this.tipsMessage = "--", this.nextString = "下一步",this.isShowReact=false});
}

