@PlatformDetector()
import 'package:flutter_platform_code_demo/builder/platform_annotation.dart';
import 'package:flutter_platform_code_demo/builder/platform_generator.dart';

@PlatformSpec(platformType: PlatformType.mobile)
class Util {
  print(String str) => print('Mobile: $str');
}

@PlatformSpec(platformType: PlatformType.desktop, renameTo: 'Util')
class UtilForDesktop {
  print(String str) => print('Desktop: $str');
}
