import 'dart:ffi';  // Dart FFI包
import 'dart:io' show Platform;  // 用于确定平台
import 'package:ffi/ffi.dart';  // 用于内存分配和释放

// 定义Rust函数的签名
typedef CompressImageFunc = Pointer<Uint8> Function(
    Pointer<Utf8> inputPath, Pointer<Utf8> format, Uint8 quality, Pointer<IntPtr> outputLen);
typedef CompressImageDart = Pointer<Uint8> Function(
    Pointer<Utf8> inputPath, Pointer<Utf8> format, int quality, Pointer<IntPtr> outputLen);

// 加载动态库
final DynamicLibrary rustLib = Platform.isMacOS
    ? DynamicLibrary.open('librust_lib.dylib')
    : Platform.isWindows
        ? DynamicLibrary.open('rust_lib.dll')
        : DynamicLibrary.open('rust_lib.so');

// 获取Rust函数
final compressImage = rustLib
    .lookupFunction<CompressImageFunc, CompressImageDart>('compress_image');

// 释放内存的函数签名
typedef FreeMemoryFunc = Void Function(Pointer<Uint8> ptr);
typedef FreeMemoryDart = void Function(Pointer<Uint8> ptr);

// 获取释放内存的函数
final freeMemory = rustLib
    .lookupFunction<FreeMemoryFunc, FreeMemoryDart>('free_memory');
