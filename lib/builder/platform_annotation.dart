enum PlatformType {
  mobile,
  desktop,
}

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
