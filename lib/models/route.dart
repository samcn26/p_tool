import 'package:flutter/material.dart';
import 'package:p_tool/pages/image_tool.dart';
import 'package:p_tool/pages/tool1.dart';
import 'package:p_tool/pages/tool2.dart';

class AppRoute {
  // for Menu cached lazy loading
  static final Map<String, Widget> linksMenuMap = {
    ImageTool.path: const ImageTool(),
    Tool1.path: const Tool1(),
    Tool2.path: const Tool2(),
  };

  static final Map<String, Widget> linksPageMap = {
    "/": const ImageTool(),
    ...linksMenuMap
  };
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget? page = linksPageMap[settings.name];
    if (page != null) {
      return MaterialPageRoute(builder: (context) => page, settings: settings);
    }
    // exception for not found
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('404 - Page not found')),
      ),
    );
  }
}
