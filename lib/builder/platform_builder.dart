import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'platform_annotation.dart';
import 'platform_generator.dart';

Builder platformBuilder(BuilderOptions options) => LibraryBuilder(
    PlatformGenerator(
      PlatformType.values.byName(options.config['platform']),
    ),
    generatedExtension: '.p.dart');
