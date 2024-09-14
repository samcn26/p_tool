import 'dart:typed_data';

import 'package:p_tool/models/format.dart';

class ImageFile {
  final String id;
  final String path;
  final String name;
  final int size;
  final Format? extention;
  Map<Format, int?>? compressedFormats;

  ImageFile({
    required this.id,
    required this.path,
    required this.name,
    required this.size,
    this.extention,
    this.compressedFormats,
  });
}

class CompressedImageFile {
  final int size;
  final String id;
  // 压缩后的图片数据
  final Uint8List data;

  CompressedImageFile({
    required this.size,
    required this.data,
    required this.id,
  });

  // 将对象转换为 JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'compressedImageData': compressedImageData.toList(), // 转换为列表
  //   };
  // }
}
