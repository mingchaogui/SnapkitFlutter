import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapkit_flutter_android/snapkit_flutter_android.dart';
import 'package:snapkit_flutter_platform_interface/snapkit_flutter_platform_interface.dart';

const Map<String, dynamic> kDefaultResponses = <String, dynamic>{
  'send': null,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final SnapkitFlutterAndroid snapkit = SnapkitFlutterAndroid();
  final MethodChannel channel = snapkit.channel;

  final List<MethodCall> log = <MethodCall>[];
  late Map<String, dynamic>
      responses; // Some tests mutate some kDefaultResponses

  setUp(() {
    responses = Map<String, dynamic>.from(kDefaultResponses);
    _ambiguate(TestDefaultBinaryMessengerBinding.instance)!
        .defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      final dynamic response = responses[methodCall.method];
      if (response != null && response is Exception) {
        return Future<dynamic>.error('$response');
      }
      return Future<dynamic>.value(response);
    });
  });

  test('registers instance', () {
    SnapkitFlutterAndroid.registerWith();
    expect(SnapkitFlutterPlatform.instance, isA<SnapkitFlutterAndroid>());
  });

  test('Other functions pass through arguments to the channel', () async {
    final Map<void Function(), Matcher> tests = <void Function(), Matcher>{
      () {
        snapkit.send(
          mediaType: SnapMediaType.photo,
          filePath: 'example.png',
        );
      }: isMethodCall('send', arguments: <String, dynamic>{
        'mediaType': SnapMediaType.photo.name,
        'filePath': 'example.png',
      }),
    };

    for (final void Function() f in tests.keys) {
      f();
    }

    expect(log, tests.values);
  });
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
T? _ambiguate<T>(T? value) => value;
