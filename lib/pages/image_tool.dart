import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageTool extends StatefulWidget {
  static String path = "/image-tool";

  const ImageTool({super.key});

  @override
  State<ImageTool> createState() => _ImageToolState();
}

class _ImageToolState extends State<ImageTool> {
  bool _hovering = false; // 控制 hover 效果
  bool _switchValue = false; // 控制 Switch 状态
  List<String> _selectedFormats = []; // 存储选中的格式

  List<String> _selectedFiles = [];

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
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                value: _switchValue,
                onChanged: (value) {
                  setState(() {
                    _switchValue = value;
                    if (!_switchValue) {
                      _selectedFormats.clear(); // 关闭时清除选中
                    }
                  });
                },
              ),
              const Text('Enable Format Selection'),
            ],
          ),
          // 格式选择选项
          if (_switchValue)
            const SizedBox(height: 20),
            Wrap(
                spacing: 10,
                children: ['WEBP', 'JPG', 'PNG', 'SELECT ALL'].map((format) {
                  return FilterChip(
                    label: Text(format),
                    selected: format == 'SELECT ALL'
                        ? _selectedFormats.contains('WEBP') &&
                            _selectedFormats.contains('JPG') &&
                            _selectedFormats
                                .contains('PNG') // 当所有格式都被选中时，SELECT ALL 自动选中
                        : _selectedFormats.contains(format),
                    onSelected: (selected) {
                      setState(() {
                        if (format == 'SELECT ALL') {
                          if (selected) {
                            _selectedFormats = ['WEBP', 'JPG', 'PNG']; // 选中所有格式
                          } else {
                            _selectedFormats.clear(); // 取消所有格式
                          }
                        } else {
                          if (selected) {
                            _selectedFormats.add(format);
                          } else {
                            _selectedFormats.remove(format);
                          }
                        }
                      });
                    },
                  );
                }).toList()),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedFiles[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
