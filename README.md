# PKUReader

PKUReader 的 Flutter 前端。

## 部署说明

### 预编译二进制包

Android 平台可在 https://github.com/pkuse72020/pkureader_frontend/releases 下载最新的二进制包，`release` 目录下也有一个二进制包。**只有 v0.2-alpha.1 及以上版本的预编译二进制包才可以在 Android 平台上正常使用。**

### 自行构建

iOS 平台和 Android 平台可根据 https://flutter.cn/docs/get-started/install 中的指南自行构建安装，中途可能需要在本代码根目录执行 `flutter pub get`。

## 主要参考资料

[1] [Flutter 中文资源主页](https://flutter.cn)

[2] [Flutter - Beautiful native apps in record time](https://flutter.dev)

[3] UI 参考了 https://github.com/mitesh77/Best-Flutter-UI-Templates 中的实现，使用了其部分代码

[4] 高亮关键词参考了 [hightlight_text 包](https://pub.flutter-io.cn/packages/highlight_text)（[GitHub](https://github.com/desconexo/highlight_text)） 中的实现，使用了其部分代码

[5] flutter_html 来自 [flutter_html 包](https://pub.flutter-io.cn/packages/flutter_html)（[GitHub](https://github.com/Sub6Resources/flutter_html)） 中的实现，我们对它进行了修改，以实现 HTML 中关键词高亮的功能

