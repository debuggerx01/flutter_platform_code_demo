# flutter_platform_code_demo

尝试利用`source_gen`自定义代码生成器，解决跨平台开发时差异代码替换的问题。

# DEMO使用方法

1. clone本仓库
2. 下载依赖`flutter pub get`
3. 运行代码生成：

```shell
flutter pub run build_runner build
```

4. 查看`lib`目录下生成的`*.p.dart`代码，或直接运行项目查看效果

## 指定生成代码平台的方法

### 方法一

1. 修改`build.yaml`，修改最后一行`platform: `的值：

```yaml
      options:
        platform: desktop
```

> 当前可选`mobile`和`desktop`

2. 运行代码生成：

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```

### 方法二

直接在代码生成命令中加入options覆盖参数：

- desktop:

```shell
flutter pub run build_runner build --delete-conflicting-outputs --define "flutter_platform_code_demo:platform_builder=platform=desktop"
```

- mobile:

```shell
flutter pub run build_runner build --delete-conflicting-outputs --define "flutter_platform_code_demo:platform_builder=platform=mobile"
```

# 注解使用说明
参考[source_gen](https://pub.flutter-io.cn/packages/source_gen)的文档和用例，需要使用注解来指定需要代码生成器处理的源码和元素。

## @PlatformDetector
这是用来标记需要进行代码替换的注解标记，无需解释，放在需要处理的代码源文件的第一行即可

## @PlatformSpec
这是用来标记需要替换的元素的注解，注解签名为：

```dart
PlatformSpec({
    required this.platformType,
    this.renameTo,
})

```

其中：

- `platformType`必须指定，当与当前指定的PlatformType不一致时，生成的代码中该注解所标记的代码块将被移除；
- `renameTo`为可选，当改注解标记的代码块需要保留时，如果指定了`renameTo`，那么根据代码块类型的不同，将进行相应的替换

## 增加 PlatformType 的方法

在`lib/builder/platform_generator.dart`顶部的`PlatformType`枚举中增加类型：

```dart
enum PlatformType {
  mobile,
  desktop,
  // add some other platform type here
}
```



# 当前支持替换的语法元素

- 类定义（ClassDeclaration）

- 变量定义（VariableDeclaration）

- 顶层变量定义（TopLevelVariableDeclaration）

- 字段定义（FieldDeclaration）

- import指令（ImportDirective）

- 函数定义（FunctionDeclaration）

- 方法定义（MethodDeclaration）

  > 更多语法支持可以通过在`lib/builder/platform_generator.dart`中增加`visitXXX`系列的方法覆写来实现。

# 举例

源代码`test.dart`：

```dart
@PlatformDetector()
import 'package:flutter_platform_code_demo/builder/platform_generator.dart';
@PlatformSpec(platformType: PlatformType.mobile)
import 'messages/mobile.dart';
@PlatformSpec(platformType: PlatformType.desktop, renameTo: 'messages/desktop.dart')
// ignore: duplicate_import
import 'messages/mobile.dart';
import 'builder/platform_annotation.dart';

@PlatformSpec(platformType: PlatformType.mobile)
const _title = 'Flutter Demo Mobile';

@PlatformSpec(platformType: PlatformType.desktop, renameTo: '_title')
// ignore: unused_element
const _titleDesktop = 'Flutter Demo Desktop';

class A {
  @PlatformSpec(platformType: PlatformType.mobile)
  int _counter = 0;

  @PlatformSpec(platformType: PlatformType.desktop, renameTo: '_counter')
  // ignore: unused_field, prefer_final_fields
  int _counterDesktop = 9;

  @PlatformSpec(platformType: PlatformType.mobile, renameTo: '_incrementCounter')
  // ignore: unused_element
  void _incrementCounterMobile() {
    _counter++;
  }

  @PlatformSpec(platformType: PlatformType.desktop)
  void _incrementCounter() {
    _counter *= 2;
  }
}

@PlatformSpec(platformType: PlatformType.mobile)
class B {
  final name = 'mobile';
}

@PlatformSpec(platformType: PlatformType.desktop, renameTo: 'B')
class C {
  final name = 'desktop';
}

```

在指定`PlatformType`为`mobile`时将生成如下`test.p.dart`代码：

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// PlatformGenerator
// **************************************************************************

@PlatformDetector()
import 'package:flutter_platform_code_demo/builder/platform_generator.dart';
@PlatformSpec(platformType: PlatformType.mobile)
import 'messages/mobile.dart';
import 'builder/platform_annotation.dart';

const _title = 'Flutter Demo Mobile';

class A {
  @PlatformSpec(platformType: PlatformType.mobile)
  int _counter = 0;
  @PlatformSpec(
      platformType: PlatformType.mobile, renameTo: '_incrementCounter')
  void _incrementCounter() {
    _counter++;
  }
}

@PlatformSpec(platformType: PlatformType.mobile)
class B {
  final name = 'mobile';
}

```

在指定`PlatformType`为`desktop`时将生成如下`test.p.dart`代码：

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// PlatformGenerator
// **************************************************************************

@PlatformDetector()
import 'package:flutter_platform_code_demo/builder/platform_generator.dart';
@PlatformSpec(
    platformType: PlatformType.desktop, renameTo: 'messages/desktop.dart')
import 'messages/desktop.dart';
import 'builder/platform_annotation.dart';

const _title = 'Flutter Demo Desktop';

class A {
  @PlatformSpec(platformType: PlatformType.desktop, renameTo: '_counter')
  int _counter = 9;
  @PlatformSpec(platformType: PlatformType.desktop)
  void _incrementCounter() {
    _counter *= 2;
  }
}

@PlatformSpec(platformType: PlatformType.desktop, renameTo: 'B')
class B {
  final name = 'desktop';
}

```

