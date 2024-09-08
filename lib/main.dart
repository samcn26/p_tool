import 'package:flutter/material.dart';
import 'package:p_tool/models/route.dart';
import 'package:p_tool/pages/image_tool.dart';
import 'package:p_tool/pages/tool1.dart';
import 'package:p_tool/widgets/side_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  bool _isSidebarVisible = true;
  static final List<String> _menuPath = [ImageTool.path, Tool1.path];
  late List<Widget?> _pages;

  // lazy loading strategy
  void _loadPage(int index) {
    if (_pages[index] == null) {
      _pages[index] = AppRoute.linksMenuMap[_menuPath[index]];
    }
  }

  @override
  void initState() {
    super.initState();
    _pages = List.filled(_menuPath.length, null);
    _loadPage(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    void setSelectedIndex(index) {
      setState(() {
        _selectedIndex = index;
        _loadPage(_selectedIndex);
      });
    }

    return MaterialApp(
      title: 'P Tool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // darkTheme: ThemeData(
      //   useMaterial3: true,
      //   // 暗黑模式
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.blue,
      //     brightness: Brightness.dark,
      //   ),
      // ),
      onGenerateRoute: AppRoute.onGenerateRoute,

      home: Scaffold(
        body: Row(
          children: <Widget>[
            SideBar(
                selectedIndex: _selectedIndex,
                setSelectedIndex: setSelectedIndex,
                menus: [
                  MenuItem(name: "Image Tool", route: "/image-tool"),
                  MenuItem(name: "Tool1", route: "/tool1"),
                ],
                visible: _isSidebarVisible),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IndexedStack(
                  index: _selectedIndex,
                  children:
                      _pages.map((page) => page ?? const SizedBox.shrink()).toList(),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isSidebarVisible = !_isSidebarVisible;
            });
          },
          child: Icon(_isSidebarVisible ? Icons.menu_open : Icons.menu),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
