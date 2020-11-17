import 'package:flutter/widgets.dart';
import 'package:user_guidcance_example/page/guidance_step_page.dart';
import 'package:user_guidcance_example/page/guidance_normal_page.dart';
import 'package:user_guidcance_example/common/router_name.dart';

Map<String, Widget Function(BuildContext)> createRouter(BuildContext context) {
  return {
    GUIDANCE_NORMAL_PAGE: (context) => GuidanceNormalPage(),
    GUIDANCE_STEP_PAGE: (context) => GuidanceStepPage(),
  };
}
