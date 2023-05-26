import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:snapkit_flutter/snapkit_flutter.dart';
import 'package:snapkit_flutter_platform_interface/snapkit_flutter_platform_interface.dart';

import 'snapkit_flutter_test.mocks.dart' as base_mock;

// Add the mixin to make the platform interface accept the mock.
class _MockSnapkitFlutterPlatform extends base_mock.MockSnapkitFlutterPlatform
    with MockPlatformInterfaceMixin {}

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<SnapkitFlutterPlatform>(),
])
void main() {
  late _MockSnapkitFlutterPlatform mockPlatform;

  setUp(() {
    mockPlatform = _MockSnapkitFlutterPlatform();
    SnapkitFlutterPlatform.instance = mockPlatform;
  });

  group('#Send content', () {
    setUp(() {
      when(mockPlatform.send(
        mediaType: anyNamed('mediaType'),
        filePath: anyNamed('filePath'),
        sticker: anyNamed('sticker'),
        attachmentUrl: anyNamed('attachmentUrl'),
        caption: anyNamed('caption'),
      )).thenAnswer((Invocation _) async {});
    });

    test('send none', () async {
      await SnapkitFlutter.instance.send(mediaType: SnapMediaType.none);
      verify(mockPlatform.send(mediaType: SnapMediaType.none));
    });

    test('send file', () async {
      const SnapSticker sticker = SnapSticker(
        filePath: 'sticker.png',
        width: 100,
        height: 100,
      );

      await SnapkitFlutter.instance.send(
        mediaType: SnapMediaType.photo,
        filePath: 'example.png',
        sticker: sticker,
        attachmentUrl: 'https://flutter.dev',
        caption: 'Snapkit Flutter',
      );
      await SnapkitFlutter.instance.send(
        mediaType: SnapMediaType.video,
        filePath: 'example.mp4',
        sticker: sticker,
        attachmentUrl: 'https://flutter.dev',
        caption: 'Snapkit Flutter',
      );

      verifyInOrder(<Object>[
        mockPlatform.send(
          mediaType: SnapMediaType.photo,
          filePath: argThat(contains('png'), named: 'filePath'),
          sticker: argThat(isInstanceOf<SnapSticker>(), named: 'sticker'),
          attachmentUrl: argThat(isNotEmpty, named: 'attachmentUrl'),
          caption: argThat(isNotEmpty, named: 'caption'),
        ),
        mockPlatform.send(
          mediaType: SnapMediaType.video,
          filePath: argThat(contains('mp4'), named: 'filePath'),
          sticker: argThat(isInstanceOf<SnapSticker>(), named: 'sticker'),
          attachmentUrl: argThat(isNotEmpty, named: 'attachmentUrl'),
          caption: argThat(isNotEmpty, named: 'caption'),
        ),
      ]);
    });
  });
}
