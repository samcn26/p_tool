import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:p_tool/models/format.dart';
import 'package:p_tool/pages/image_tool.dart';

class ImageFormaterItem extends StatefulWidget {
  const ImageFormaterItem(
      {super.key, required this.path, this.cb, required this.formatCommand});

  final String path;
  final void Function(String content, int index)? cb;
  final Map<Format, bool> formatCommand;

  @override
  State<ImageFormaterItem> createState() => _ImageFormaterItemState();
}

class _ImageFormaterItemState extends State<ImageFormaterItem> {
  final Map<Format, bool> _cachedFormatStatus = {
    Format.webp: false,
    Format.jpg: false,
    Format.png: false,
  };

  final Map<Format, String> _compressedFormatSize = {
    Format.webp: "",
    Format.jpg: "",
    Format.png: "",
  };

  late String _fileName = "";
  late String _originSize = "";

  @override
  void initState() {
    super.initState();
    if (widget.path.isNotEmpty) {
      setState(() {
        _fileName = p.basenameWithoutExtension(widget.path);
      });

      String extention = p.extension(widget.path).substring(1);

      // 压缩
      print("$extention compress is done");
    }
  }

  @override
  void didUpdateWidget(covariant ImageFormaterItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当文件路径发生变化时，处理文件名

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      // width: double.infinity,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //   for image rounded 8
        Expanded(
          // 确保图片占满可用空间
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover, // 图片适应方式
              ),
            ),
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(8), // 设置圆角
        //   child: AspectRatio(
        //     aspectRatio: 1 / 1,
        //     child: Image.file(
        //       File(widget.path),
        //       fit: BoxFit.cover, // 图片适应方式
        //     ),
        //   ),
        // ),
        const SizedBox(
          height: 10,
        ),
        Text(
          _fileName,
          maxLines: 1, // 限制显示为一行
          overflow: TextOverflow.ellipsis, // 超出部分显示省略号
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _cachedFormatStatus.entries
                .where((x) => x.value)
                .map(
                  (e) => ActionChip(
                    label: Column(
                      children: [
                        Text(formatOptionMap[e.key]!),
                        const Text(
                          "123.234K",
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                        )
                      ],
                    ),
                    onPressed: () {
                      print('download $_fileName, ${e.key}');
                    },
                  ),
                )
                .toList())
      ],
    );
  }
}
