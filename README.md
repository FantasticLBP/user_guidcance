![user guidance](./icon_logo.png)



**User guidance is an easy way to use new function guidance.**



## Video

![](./user_guidance.mp4)

 

## Installation

1. 安装依赖

   ```yaml
   dev_dependencies:
     user_guidcance: ^0.0.1
   ```

2. 引入文件

   ```dart
   import 'package:user_guidcance/guidance_ui.dart';
   ```



##  Basic Example

```dart
List<GuidanceContextInfo> curvePointList = [];
GuidanceContextInfo contextModel = GuidanceContextInfo(
  title: '1. 新功能哦', 
  context: '大佬，这是一个新开发的功能哦，主要是为了让你方便的知道当前功能的使用方法，快速上手', 
  buttonText: '下一步', 
  rectType: GuidanceRectType.circle,  // 引导效果的样式，GuidanceRectType.circle、GuidanceRectType.rectangle
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
```



## Learn User Guidance

核心思想：根据元素的位置，利用动画展示新功能的信息。

1. 元素的位置。

   不需要用户计算传递，根据元素的 GlobalKey 属性来计算元素的位置。

   ````dart
   RenderBox element = elementKey.currentContext.findRenderObject();
   Size size = element.size;
   Offset position = element.localToGlobal(Offset(0, 0));
   Rect rect = Rect.fromLTRB(position.dx, position.dy, position.dx + size.width, position.dy + size.height);
   ````

2. 根据元素在屏幕上的位置决定对话框箭头的朝向。

3. 根据 canvas 绘制对话框的样式。

   自定义的绘制类需要继承自 `CustomPainter`，重写 `paint` 方法，为了提高效率避免重复绘制，需要重写 `shouldRepaint` 方法。

   ```dart
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
   ```
   
   

## Change Log

[Change Log](./changeLog.md)



## License 

 [click here](https://github.com/FantasticLBP/user_guidcance/blob/main/LICENSE)