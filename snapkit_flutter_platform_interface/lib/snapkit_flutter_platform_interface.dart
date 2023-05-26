import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/media_type.dart';
import 'src/sticker.dart';

export 'src/media_type.dart';
export 'src/sticker.dart';

abstract class SnapkitFlutterPlatform extends PlatformInterface {
  /// Constructs a SnapkitFlutterPlatformInterface.
  SnapkitFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SnapkitFlutterPlatform _instance = _PlaceholderImplementation();

  /// The default instance of [SnapkitFlutterPlatform] to use.
  ///
  /// Must be set before accessing.
  static SnapkitFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SnapkitFlutterPlatform] when
  /// they register themselves.
  static set instance(SnapkitFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> send({
    required SnapMediaType mediaType,
    String? filePath,
    SnapSticker? sticker,
    String? attachmentUrl,
    String? caption,
  }) {
    throw UnimplementedError('send() has not been implemented.');
  }
}

class _PlaceholderImplementation extends SnapkitFlutterPlatform {}
