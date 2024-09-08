import 'dart:io';

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
    Format.webp: true,
    Format.jpg: true,
    Format.png: true,
  };

  final _fileName = "test";

  // format content

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
        SizedBox(height: 10,),
        Text(
          _fileName,
          maxLines: 1, // 限制显示为一行
          overflow: TextOverflow.ellipsis, // 超出部分显示省略号
        ),
        SizedBox(height: 10,),
        Row(
            children: _cachedFormatStatus.entries
                .where((x) => x.value)
                .map((e) => Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ActionChip(
                        label: Column(children: [
                          Text(formatOptionMap[e.key]!),
                          Text("123.234K", style: TextStyle(fontSize: 10,color: Colors.black54),)
                        ],),
                        onPressed: () {
                          print('download $_fileName, ${e.key}');
                        },
                      ),
                    ))
                .toList())
      ],
    );
  }
}
