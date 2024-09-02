import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final String route;

  MenuItem({required this.name, required this.route});
}

class SideBar extends StatefulWidget {
  const SideBar(
      {super.key,
      required this.menus,
      required this.visible,
      this.maxWidth = 250,
      required this.setSelectedIndex,
      required this.selectedIndex});

  final List<MenuItem> menus;
  final bool visible;
  final double maxWidth;
  final Function(int index) setSelectedIndex;
  final int selectedIndex;

  static Widget createItem(
      {required bool active,
      required String label,
      required VoidCallback onPressed,
      EdgeInsets? padding}) {
    final ButtonStyle buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsets>(
        padding ?? const EdgeInsets.symmetric(horizontal: 16),
      ),
      alignment: Alignment.centerLeft,
    );

    return active
        ? FilledButton.tonal(
            style: buttonStyle,
            onPressed: onPressed,
            child: Text(label),
          )
        : TextButton(
            style: buttonStyle,
            onPressed: onPressed,
            child: Text(label),
          );
  }

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !widget.visible,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 180,
            maxWidth: 250,
          ),
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                  child: Center(
                    child: Icon(Icons.settings, size: 24),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(widget.menus.length, (index) {
                        final isSelected = index == widget.selectedIndex;
                        return SizedBox(
                          width: double.infinity, // 撑满整个宽度
                          child: SideBar.createItem(
                            active: isSelected,
                            label: widget.menus[index].name,
                            onPressed: () {
                              widget.setSelectedIndex(index);
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
