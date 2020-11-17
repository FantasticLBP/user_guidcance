import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_guidcance/guidance_ui.dart';

class GuidanceNormalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey elementKey = GlobalKey();
    final size = MediaQuery.of(context).size;

    Future.delayed(Duration(seconds: 1), (){  
      List<GuidanceContextInfo> curvePointList = [];
      GuidanceContextInfo contextModel = GuidanceContextInfo(
        title: null, 
        context: '客观，这里是新功能，欢迎尝鲜体验哦！',
         buttonText: '好的，知道了', 
         rectType: GuidanceRectType.rectangle, 
         ovalKey: elementKey, 
         elementKey: elementKey , 
         clipContext: context
        );
      curvePointList.add(contextModel);

      UserGuidance(
          context,
          contextModels: curvePointList,
          colorShadow: Colors.black,
          textSkip: "跳过",
          hideSkip: true,
          opacityShadow: 0.8, 
          onFinish: () => print('引导完成'),
          onClickTarget: (target) => {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop();
            })
          },
          onClickSkip: () => print('点击跳过')
      )..show();
    });

    return CupertinoPageScaffold(
        child: Container(
        margin: EdgeInsets.fromLTRB(16, 192 - 64.0, 16, size.height - 192 - 156),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.grey,
                child: Center(
                  child: null,
                ),
                key: elementKey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
