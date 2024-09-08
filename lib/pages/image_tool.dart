import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:p_tool/models/format.dart';
import 'package:p_tool/widgets/image_formater_item.dart';

final formatOptions = [
  buildOption(Format.webp),
  buildOption(Format.jpg),
  buildOption(Format.png),
  buildOption(Format.all),
];

const formatOptionMap = {
  Format.webp: "WEBP",
  Format.jpg: "JPG",
  Format.png: "PNG",
  Format.all: "SELECT ALL"
};

FormatOption buildOption(Format format) {
  return FormatOption(format, formatOptionMap[format]!);
}

class ImageTool extends StatefulWidget {
  static String path = "/image-tool";

  const ImageTool({super.key});

  @override
  State<ImageTool> createState() => _ImageToolState();
}

const maxSelectCount = 10;

class _ImageToolState extends State<ImageTool> {
  bool _hovering = false; // 控制 hover 效果
  Map<Format, bool> formatMap = {
    Format.webp: false,
    Format.jpg: false,
    Format.png: false,
    Format.all: false
  };
  List<String> _selectedFiles = [];
  final List<Format> commonItems = [Format.jpg, Format.webp, Format.png];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // 允许多选
      type: FileType.custom, // 自定义文件类型
      allowedExtensions: ['jpg', 'webp', 'png'], // 允许的文件扩展名
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.paths.map((path) => path!).toList();
      });
      print(_selectedFiles);
    }
  }

  VoidCallback handleAllOption = () {};

  @override
  Widget build(BuildContext context) {
    // var formatCommand = Map.fromEntries(
    //     formatMap.entries.where((entry) => entry.key != Format.all)
    // );
    return Scaffold(
      appBar: AppBar(title: const Text("Image Tool")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _pickFiles,
            child: MouseRegion(
              cursor: SystemMouseCursors.click, // 设置鼠标指针为 "pointer"
              onEnter: (_) {
                setState(() {
                  _hovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _hovering = false;
                });
              },
              child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _hovering ? Colors.blue : Colors.grey, // hover 变色
                      width: 2,
                    ),
                    color: _hovering
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 60,
                        color: _hovering ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Drag & Drop or Click to Upload Files',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 20),
          // Switch 控件和选项
          Wrap(
              spacing: 20,
              children: formatOptions
                  .map((opt) =>
                  Row(
                    // 不占一行
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                          key: ValueKey(opt.label),
                          value: formatMap[opt.value] ?? false,
                          onChanged: (v) {
                            setState(() {
                              formatMap[opt.value] = v!;

                              if (opt.value == Format.all) {
                                for (var e in commonItems) {
                                  formatMap[e] = v;
                                }
                              } else {
                                if (!v) {
                                  formatMap[Format.all] = false;
                                } else {
                                  bool allSelected = commonItems
                                      .every((e) => formatMap[e] == true);
                                  formatMap[Format.all] = allSelected;
                                }
                              }
                            });
                          }),
                      Text(opt.label)
                    ],
                  ))
                  .toList()),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 items per row
                  crossAxisSpacing: 20, // Horizontal space between items
                  mainAxisSpacing: 20, // Vertical space between rows
                  // childAspectRatio: 0.8, // Aspect ratio for each item
                ),
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  return ImageFormaterItem(path: _selectedFiles[index], formatCommand: formatMap);
                }),
          )
          //
          // SizedBox(width: 200,
          //     child: ImageFormaterItem(
          //         path: "/test.png", formatCommand: formatMap))
        ],
      ),
    );
  }
}
