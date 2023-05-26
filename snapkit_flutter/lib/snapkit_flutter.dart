import 'package:snapkit_flutter_platform_interface/snapkit_flutter_platform_interface.dart';

export 'package:snapkit_flutter_platform_interface/snapkit_flutter_platform_interface.dart'
    show SnapMediaType, SnapSticker;

class SnapkitFlutter extends SnapkitFlutterPlatform {
  SnapkitFlutter._();

  static SnapkitFlutter? _instance;

  /// The instance of the [SnapkitFlutter] to use.
  // ignore: prefer_constructors_over_static_methods
  static SnapkitFlutter get instance => _instance ??= SnapkitFlutter._();

  @override
  Future<void> send({
    required SnapMediaType mediaType,
    String? filePath,
    SnapSticker? sticker,
    String? attachmentUrl,
    String? caption,
  }) {
    assert(() {
      if (mediaType == SnapMediaType.none) {
        return filePath == null;
      }
      return filePath != null;
    }());

    return SnapkitFlutterPlatform.instance.send(
      mediaType: mediaType,
      filePath: filePath,
      sticker: sticker,
      attachmentUrl: attachmentUrl,
      caption: caption,
    );
  }
}
