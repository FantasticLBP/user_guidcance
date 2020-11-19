import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_guidcance_example/router/router.dart';
import 'package:user_guidcance_example/page/guidance_normal_page.dart';
import 'package:user_guidcance_example/page/guidance_step_page.dart';
import 'package:user_guidcance_example/common/color_setting.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppContent()
    );
  }
}

class AppContent extends StatelessWidget {
  Widget getItem(String info, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.08),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    info,
                    style: TextStyle(color: AppColors.n8, fontSize: 17),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: AppColors.n1),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 76, left: 16)
                ),
                Container(
                  child: Text(
                    "User Guidance",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: AppColors.n8,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900
                      ),
                  ),
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                ),
                Container(
                  child: Text(
                    "新功能引导 plugin，可以快速指定引导的样式、位置、动画等，高效美观",
                    style: TextStyle(
                      color: AppColors.n6,
                      fontSize: 15,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                ),
                getItem("矩形引导", () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GuidanceNormalPage()))
                }),
                getItem("圆形引导", () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GuidanceStepPage()))
                }),
                Container(
                  height: size.height - 220,
                )
              ],
            ),
          ),
        )),
        routes: createRouter(context),
    );
  }
}