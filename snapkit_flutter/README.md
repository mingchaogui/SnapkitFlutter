# Snapkit Flutter

[![Pub Package](https://img.shields.io/pub/v/snapkit_flutter.svg)](https://pub.dev/packages/snapkit_flutter)

A plugin that allows developers like you to integrate with Snapchat (using [SnapKit](https://kit.snapchat.com)) into your Flutter applications!

## Getting Started

### Android

[Creative Kit](https://docs.snap.com/snap-kit/creative-kit/Tutorials/android#get-started)

### iOS

[Creative Kit](https://docs.snap.com/snap-kit/creative-kit/Tutorials/ios#get-started)

## Send to Snapchat

### Send to LIVE
```dart
SnapkitFlutter.instance.send(mediaType: SnapMediaType.none);
```

### Send with Photo
```dart
SnapkitFlutter.instance.send(
  mediaType: SnapMediaType.photo,
  filePath: String,
  sticker: SnapSticker?,
  attachmentUrl: String?
  caption: String?,
);
```

### Send with Video
```dart
SnapkitFlutter.instance.send(
  mediaType: SnapMediaType.video,
  filePath: String,
  sticker: SnapSticker?,
  attachmentUrl: String?
  caption: String?,
);
```
