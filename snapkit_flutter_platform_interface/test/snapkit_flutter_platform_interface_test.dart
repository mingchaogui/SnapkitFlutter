import 'package:flutter_test/flutter_test.dart';
import 'package:snapkit_flutter_platform_interface/snapkit_flutter_platform_interface.dart';

void main() {
  // Store the initial instance before any tests change it.
  final SnapkitFlutterPlatform initialInstance =
      SnapkitFlutterPlatform.instance;

  test('default implementation throws uninimpletemented', () async {
    await expectLater(
      () => initialInstance.send(mediaType: SnapMediaType.none),
      throwsUnimplementedError,
    );
  });
}
