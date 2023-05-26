import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:snapkit_flutter_platform_interface/snapkit_flutter_platform_interface.dart';

const String _kMethodChannelName =
    'plugins.mintinglabs.com/snapkit_flutter_ios';

class SnapkitFlutterIos extends SnapkitFlutterPlatform {
  /// This is only exposed for test purposes. It shouldn't be used by clients of
  /// the plugin as it may break or change at any time.
  @visibleForTesting
  final MethodChannel channel = const MethodChannel(_kMethodChannelName);

  /// Registers this class as the default instance of [SnapkitFlutterPlatform].
  static void registerWith() {
    // Register the platform instance with the plugin platform
    // interface.
    SnapkitFlutterPlatform.instance = SnapkitFlutterIos();
  }

  @override
  Future<void> send({
    required SnapMediaType mediaType,
    String? filePath,
    SnapSticker? sticker,
    String? attachmentUrl,
    String? caption,
  }) {
    return channel.invokeMethod('send', <String, dynamic>{
      'mediaType': mediaType.name,
      'filePath': filePath,
      'sticker': sticker?.toMap(),
      'attachmentUrl': attachmentUrl,
      'caption': caption,
    });
  }
}
