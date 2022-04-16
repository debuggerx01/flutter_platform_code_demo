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

