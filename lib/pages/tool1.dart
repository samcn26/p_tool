import 'package:flutter/material.dart';
import 'package:p_tool/pages/tool2.dart';

class Tool1 extends StatelessWidget {
  static String path = '/tool1';
  const Tool1({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: Tool1.path,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case "/tool2":
            builder = (BuildContext _) => const Tool2();
            break;
          case "/tool1":
          default:
            builder = (BuildContext _) => const Tool1Home();
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class Tool1Home extends StatefulWidget {
  const Tool1Home({super.key});

  @override
  State<Tool1Home> createState() => _Tool1HomeState();
}

class _Tool1HomeState extends State<Tool1Home> {
  Color _inPageColor = Colors.white70;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: const Text("tool 1")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: _inPageColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(Tool2.path); // 使用嵌套 Navigator 进行导航
              },
              child: const Text("Go to Tool2"),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _inPageColor = Colors.lightBlueAccent;
                  });
                },
                child: const Text("Change State"))
          ],
        ),
      ),
    );
  }
}
