# p_tool

A new Flutter project.

## FFI Plugin

flutter_rust_bridge_codegen

这个错误表明 `libadd.dylib` 文件没有经过代码签名（CodeSign），而 macOS 要求在应用程序中使用的动态库需要签名，尤其是在开发或调试模式下。

### 解决方法：

#### 1. **通过 Xcode 进行代码签名**

你可以通过 Xcode 直接为 `.dylib` 文件进行签名。以下是步骤：

1. **打开 Xcode 项目**：
   - 在项目的 `macos/Runner.xcworkspace` 文件中打开 Xcode。

2. **选择项目目标（Target）**：
   - 在 Xcode 左侧的导航栏中，选择 `Runner` 项目，然后选择 `Runner` target。

3. **添加 `Copy Files Phase`**：
   - 转到 `Build Phases` 标签，点击左上角的 `+` 按钮并选择 `New Copy Files Phase`。
   - 将 `Destination` 设置为 `Frameworks`。
   - 点击 `+` 按钮，添加 `libadd.dylib` 文件到此 `Copy Files` 阶段。

4. **代码签名**：
   - 在 `Build Phases` 中，找到 `Code Signing` 阶段。
   - 确保动态库（`libadd.dylib`）被列在需要签名的文件中。
   - 你可以手动签名，打开终端，并输入如下命令：
     ```bash
     sudo codesign --force --deep --sign - <path_to_your_dylib>
     ```

   例如：
   ```bash
   sudo codesign --force --deep --sign - /Users/sam-tech/devops/flutter/p_tool/build/macos/Build/Products/Debug/p_tool.app/Contents/Frameworks/libadd.dylib
   ```

#### 2. **禁用代码签名检查（仅用于调试）**

如果你只是在本地开发和调试，可以考虑临时禁用 macOS 对库的签名检查。

1. **修改 Xcode 设置**：
   - 在 Xcode 中，打开 `Build Settings`。
   - 找到 `Code Signing` 相关选项，将 `Code Signing Identity` 设置为 `Ad-Hoc` 或 `Don't Code Sign`。
   
2. **命令行禁用签名**（此方法并不推荐用于发布应用，仅供本地测试使用）：
   - 你可以修改 macOS 的 `codesign` 设置，允许加载未签名的库：
   ```bash
   sudo spctl --master-disable
   ```

   这将关闭 macOS 的签名强制检查，但请记住，这仅适用于开发环境，正式发布时不能依赖这种方式。

#### 3. **将 `libadd.dylib` 文件签名到你的应用程序中**

你可以在 Xcode 中的 `Runner` target 的 `Build Phases` 中，添加一个脚本来签名该库，确保每次编译都自动签名：

```bash
codesign --force --deep --sign "$CODE_SIGN_IDENTITY" "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/libadd.dylib"
```

### 总结：
- 推荐的解决方案是确保 `.dylib` 文件被正确签名。可以通过 Xcode 或手动使用 `codesign` 命令进行签名。
- 如果只是调试，可以考虑临时禁用签名检查，但这不适用于发布。

尝试这些方法后，再重新构建项目。
