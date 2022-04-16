import 'platform_generator.dart';

class PlatformDetector {
  const PlatformDetector();
}

class PlatformSpec {
  final PlatformType platformType;
  final String? renameTo;

  const PlatformSpec({
    required this.platformType,
    this.renameTo,
  });
}
