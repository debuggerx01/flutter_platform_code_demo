@PlatformDetector()
import 'package:flutter_platform_code_demo/builder/platform_annotation.dart';

@PlatformSpec(platformType: PlatformType.mobile)
class Util {
  log(String str) => print('Mobile: $str');
}

@PlatformSpec(platformType: PlatformType.desktop, renameTo: 'Util')
class UtilForDesktop {
  log(String str) => print('Desktop: $str');
}
