### 1. **Rust 库构建**
首先，在 Rust 中创建你的动态库（`libadd.dylib`）：
```rust
#[no_mangle]
pub extern "C" fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

然后，编译这个库为 `.dylib` 文件：
```bash
cargo build --release
```
这会在 `target/release/` 目录下生成 `libadd.dylib` 文件。

### 2. **将 Rust 库集成到 Flutter macOS 项目**
1. **复制 `.dylib` 文件到 macOS 项目**  
   将生成的 `libadd.dylib` 文件复制到 Flutter 项目的 macOS 目录下，例如 `macos/Runner/` 目录：
   ```bash
   cp target/release/libadd.dylib <your_flutter_project>/macos/Runner/
   ```

2. **Flutter FFI 调用 Rust 库**  
   在 Flutter 项目中，使用 FFI 来加载和调用 Rust 库：
   
   ```dart
   import 'dart:ffi';
   import 'dart:io';

   typedef NativeAdd = Int32 Function(Int32 a, Int32 b);
   typedef NativeAddDart = int Function(int a, int b);

   class RustLibrary {
     late DynamicLibrary _dylib;

     RustLibrary() {
       // Adjust the path depending on where you place the dylib
       final path = '${Directory.current.path}/macos/Runner/libadd.dylib';
       _dylib = DynamicLibrary.open(path);
     }

     int nativeAdd(int a, int b) {
       final add = _dylib.lookupFunction<NativeAdd, NativeAddDart>('add');
       return add(a, b);
     }
   }
   ```

### 3. **在 Xcode 中设置**
1. **打开 Xcode**  
   打开 Flutter 项目的 macOS 目录：  
   ```
   <your_flutter_project>/macos/Runner.xcworkspace
   ```

2. **将 `.dylib` 文件添加到项目中**  
   - 右键点击 `Runner` 项目，选择 `Add Files to "Runner"...`，将 `libadd.dylib` 添加进来。
   - 确保 `.dylib` 文件被复制到目标文件夹中，选择 `Copy items if needed`。

3. **确保动态库包含在构建中**  
   - 在 Xcode 中，导航到 `Runner > Build Phases`。
   - 找到 `Copy Files` 阶段，确保将 `libadd.dylib` 复制到 `Frameworks` 文件夹下。路径为 `Contents/Frameworks/`。

### 4. **签名动态库**
1. **签名 `.dylib` 文件**  
   你需要对 `.dylib` 文件进行签名，以确保它可以通过 macOS 的安全机制。
   ```bash
   sudo codesign --force --deep --sign - <your_flutter_project>/macos/Runner/libadd.dylib
   ```

2. **签名整个应用程序**  
   为应用程序包签名，确保应用的所有代码和库都被正确签名：
   ```bash
   sudo codesign --force --deep --sign - <your_flutter_project>/build/macos/Build/Products/Release/<app_name>.app
   ```

### 5. **Flutter 构建 macOS 应用**
1. **执行 Flutter 构建命令**
   使用以下命令构建 macOS 应用程序：
   ```bash
   flutter build macos
   ```

2. **验证构建输出**  
   构建完成后，确保生成的 `.app` 文件中包含动态库：
   ```bash
   <your_flutter_project>/build/macos/Build/Products/Release/<app_name>.app/Contents/Frameworks/libadd.dylib
   ```

3. **验证签名**
   确保 `.dylib` 文件和应用程序都已经签名：
   ```bash
   codesign -v <path_to_your_app>.app
   codesign -v <path_to_your_dylib>.dylib
   ```

### 6. **打包并发布（可选）**
如果你要发布这个应用程序，还需要进行 **Notarization**（应用公证）：
```bash
xcrun altool --notarize-app --primary-bundle-id "com.example.yourapp" --username "apple_id@example.com" --password "app-specific-password" --file <path_to_your_app>.app
```
然后将公证票据附加到应用程序中：
```bash
xcrun stapler staple <path_to_your_app>.app
```

### 7. **`.gitignore` 配置**
为了避免将无关的构建文件提交到 Git，你可以在 `.gitignore` 中忽略以下内容：

```gitignore
# Ignore Flutter build output
build/

# Ignore macOS specific files
macos/Flutter/ephemeral/
macos/Runner.xcarchive
macos/Runner/Assets.xcassets
macos/Runner/libadd.dylib
```

通过以上步骤，你可以成功将 Rust 库集成到 Flutter macOS 项目中，并正确签名和构建应用程序。