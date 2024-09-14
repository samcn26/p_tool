import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:p_tool/models/format.dart';
import 'package:p_tool/models/image_file.dart';
import 'package:p_tool/utils/rust_library.dart';
import 'package:p_tool/utils/screen_util.dart';
import 'package:p_tool/utils/utils.dart';
import 'package:p_tool/widgets/image_formater_item.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

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
  bool _hovering = false;

  final Map<Format, bool> _formatMap = {
    Format.webp: false,
    Format.jpg: false,
    Format.png: false,
    Format.all: false
  };
  List<ImageFile> _selectedFiles = [];

  final List<Format> _commonItems = [Format.jpg, Format.webp, Format.png];

  // uuid -> format -> CompressedImageFile
  final Map<String, Map<Format, CompressedImageFile>> _compressedFormatsMap =
      {};

  Future<void> _pickFiles() async {
    // 如果已有文件，popup 弹窗
    if (_selectedFiles.isNotEmpty) {
      bool shouldContinue = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Attention"),
            content: const Text(
                "Files already exist, will overwrite the original files"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );

      if (!shouldContinue) {
        return;
      }
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // 允许多选
      type: FileType.custom, // 自定义文件类型
      allowedExtensions: ['jpg', 'webp', 'png'], // 允许的文件扩展名
    );

    if (result != null) {
      List<ImageFile> newSelectedFiles = [];
      for (String? path in result.paths) {
        final fileName = p.basenameWithoutExtension(path!);
        final file = File(path);
        final uuid = const Uuid().v4();
        final extension = p.extension(path).substring(1).toLowerCase();
        final format = FormatExtension.fromString(extension);

        if (_compressedFormatsMap[uuid] == null) {
          _compressedFormatsMap[uuid] = {};
        }
        if (_compressedFormatsMap[uuid]![format] == null) {
          // TODO rust 实现
          // compute<Map<String, dynamic>, CompressedImageFile>(
          //   Utils.compressImageInBackground,
          //   {'file': file, 'format': format},
          // ).then((compressedFile) {
          //   setState(() {
          //     _compressedFormatsMap[uuid]![format] = compressedFile;
          //   });
          // });
        }

        newSelectedFiles.add(ImageFile(
          extention: FormatExtension.fromString(extension),
          id: uuid,
          name: fileName,
          size: file.lengthSync(),
          path: path,
        ));
      }

      setState(() {
        _selectedFiles = newSelectedFiles;
      });
    }
  }

  VoidCallback handleAllOption = () {};

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
          Row(
            children: [
              ...formatOptions.map((opt) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        key: ValueKey(opt.label),
                        value: _formatMap[opt.value] ?? false,
                        onChanged: (v) {
                          setState(() {
                            _formatMap[opt.value] = v!;

                            if (opt.value == Format.all) {
                              for (var e in _commonItems) {
                                _formatMap[e] = v;
                              }
                            } else {
                              if (!v) {
                                _formatMap[Format.all] = false;
                              } else {
                                bool allSelected = _commonItems
                                    .every((e) => _formatMap[e] == true);
                                _formatMap[Format.all] = allSelected;
                              }
                            }
                          });
                        },
                      ),
                      Text(opt.label),
                      const SizedBox(width: 20),
                    ],
                  )),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _formatMap.forEach((key, value) => _formatMap[key] = false);
                    _selectedFiles.clear();
                  });
                },
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  //  TODO: 下载所有图片
                },
                child: const Text("Download All"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ScreenUtil.isSmallScreen(context)
                      ? 1
                      : 4, // 4 items per row
                  crossAxisSpacing: 20, // Horizontal space between items
                  mainAxisSpacing: 20, // Vertical space between rows
                  // childAspectRatio: 0.8, // Aspect ratio for each item
                ),
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  return ImageFormaterItem(
                    key: ValueKey(_selectedFiles[index].id),
                    id: _selectedFiles[index].id,
                    path: _selectedFiles[index].path,
                    name: _selectedFiles[index].name,
                    size: _selectedFiles[index].size,
                    compressedFormats:
                        _compressedFormatsMap[_selectedFiles[index].id]!,
                    onDownload: (path, format) {
                      // TODO: 下载图片
                    },
                  );

                  // return ImageFormaterItem(key: ValueKey(_selectedFiles[index]), path: _selectedFiles[index], formatCommand: _formatMap);
                }),
          )
        ],
      ),
    );
  }
}
