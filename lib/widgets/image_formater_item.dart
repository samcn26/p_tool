import 'dart:io';
import 'package:flutter/material.dart';
import 'package:p_tool/models/format.dart';
import 'package:p_tool/models/image_file.dart';
import 'package:p_tool/pages/image_tool.dart';
import 'package:p_tool/utils/utils.dart';

class ImageFormaterItem extends StatelessWidget {
  const ImageFormaterItem({
    super.key,
    required this.path,
    required this.name,
    required this.size,
    required this.compressedFormats,
    required this.onDownload,
    required this.id,
  });
  final String id;
  final String path;
  final String name;
  final int size;
  final Map<Format, CompressedImageFile> compressedFormats;
  final Function(String, Format) onDownload;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              Utils.formatSize(size),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: formatOptions
              .where((opt) =>
                  opt.value != Format.all &&
                  compressedFormats[opt.value] != null &&
                  compressedFormats[opt.value]?.size != 0)
              .map(
                (opt) => ActionChip(
                  label: Column(
                    children: [
                      Text(opt.label),
                      Text(
                        Utils.formatSize(compressedFormats[opt.value]!.size),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
                      )
                    ],
                  ),
                  onPressed: () {
                    onDownload(path, opt.value);
                  },
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
