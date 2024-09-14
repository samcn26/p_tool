import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:p_tool/models/format.dart';
import 'package:p_tool/models/image_file.dart';
import 'package:p_tool/utils/rust_library.dart';
import 'package:uuid/uuid.dart';
import 'dart:ffi';
import 'package:path/path.dart' as p;

class Utils {
  static String formatSize(int sizeInBytes) {
    if (sizeInBytes >= 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)}M';
    } else {
      return '${(sizeInBytes / 1024).toStringAsFixed(2)}K';
    }
  }

  // 顶层函数，用于压缩图片
  static Future<CompressedImageFile> compressImageInBackground(
      Map<String, dynamic> params) async {
    File file = params['file'];
    String inputFormat = params['format'].toLowerCase();

    // 压缩图片
    Uint8List result;
    // 使用 Rust FFI 压缩图片
    final inputPath = file.path;
    final quality = 80; // 默认质量，可以根据需要调整

    // 准备参数
    final inputPathPtr = inputPath.toNativeUtf8();
    final formatPtr = inputFormat.toNativeUtf8();
    final outputLenPtr = calloc<IntPtr>();

    try {
      // 调用 Rust 函数
      final resultPtr = compressImage(inputPathPtr, formatPtr, quality, outputLenPtr);
      if (resultPtr == nullptr) {
        throw Exception('图片压缩失败');
      }

      // 获取压缩后的数据
      final outputLen = outputLenPtr.value;
      result = resultPtr.asTypedList(outputLen);

      // 释放 Rust 分配的内存
      freeMemory(resultPtr);
    } finally {
      // 释放参数内存
      calloc.free(inputPathPtr);
      calloc.free(formatPtr);
      calloc.free(outputLenPtr);
    }

    // 返回压缩后的文件信息
    return CompressedImageFile(
      id: const Uuid().v4(),
      size: result.length,
      data: result,
    );
  }


  static Future<CompressedImageFile> compressImageInBackground3(
      Map<String, dynamic> params) async {
    File file = params['file'];
    Format inputFormat = params['format'];

    // 读取文件为 Image 对象
    final image = img.decodeImage(await file.readAsBytes());

    if (image == null) {
      throw Exception('无法解码图像');
    }

    // 压缩图片
    Uint8List result;
    switch (inputFormat) {
      // case Format.webp:
      //   result = img.encodeWebp(image);
      //   break;
      case Format.png:
        result = img.encodePng(image, level: 9);
        break;
      case Format.jpg:
      default:
        result = img.encodeJpg(image, quality: 80);
        break;
    }

    // 返回压缩后的文件信息
    return CompressedImageFile(
      id: const Uuid().v4(),
      size: result.length,
      data: result,
    );
  }

  static Future<CompressedImageFile> compressImageInBackground2(
      Map<String, dynamic> params) async {
    File file = params['file'];
    Format format = params['format'];

    // 读取文件为 Uint8List 格式
    final Uint8List fileData = await file.readAsBytes();

    // 选择压缩格式
    CompressFormat compressFormat;
    switch (format) {
      case Format.webp:
        compressFormat = CompressFormat.webp;
        break;
      case Format.png:
        compressFormat = CompressFormat.png;
        break;
      case Format.jpg:
      default:
        compressFormat = CompressFormat.jpeg;
        break;
    }

    final result = await FlutterImageCompress.compressWithList(
      fileData,
      quality: 80,
      // 宽高不变
      minHeight: 0,
      minWidth: 0,
      keepExif: true,
      format: compressFormat,
    );

    // 如果压缩成功，返回压缩后的文件信息
    return CompressedImageFile(
      id: const Uuid().v4(),
      size: result.length,
      data: Uint8List.fromList(result),
    );
  }
}
