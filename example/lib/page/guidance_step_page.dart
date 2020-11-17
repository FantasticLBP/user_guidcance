import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_guidcance/guidance_ui.dart';
import 'package:user_guidcance_example/common/color_setting.dart';

class GuidanceStepPage extends StatelessWidget {
  final GlobalKey secondKey = GlobalKey();


  void showGuidance (BuildContext context) {
    List<GuidanceContextInfo> curvePointList = [];
    GuidanceContextInfo contextModel = GuidanceContextInfo(
      title: '1. 新功能哦', 
      context: '大佬，这是一个新开发的功能哦，主要是为了让你方便的知道当前功能的使用方法，快速上手', 
      buttonText: '下一步', 
      rectType: GuidanceRectType.circle, 
      ovalKey: secondKey, 
      elementKey: secondKey, 
      clipContext: context
    );
    curvePointList.add(contextModel);

    UserGuidance(
        context,
        contextModels: curvePointList,
        colorShadow: AppColors.black,
        textSkip: "跳过",
        hideSkip: true,
        opacityShadow: 0.8, 
        onFinish: () => print('引导完成'),
        onClickTarget: (target) => {
          Future.delayed(Duration(seconds: 1), (){
            Navigator.of(context).pop();
          })
        },
        onClickSkip: () => print('点击跳过')
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1),() {
      showGuidance(context);
    });
    return CupertinoPageScaffold(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 80, 0, 0),
          child: Container(
            width: 96,
            height: 96,
            key: secondKey,
            color: Colors.transparent,
          ),
        )
    );
  }
}
