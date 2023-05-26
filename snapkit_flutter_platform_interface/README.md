# snapkit_flutter_platform_interface

A common platform interface for the [`snapkit_flutter`][1] plugin.

This interface allows platform-specific implementations of the `snapkit_flutter`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `snapkit_flutter`, extend
[`SnapkitFlutterPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`SnapkitFlutterPlatform` by calling
`SnapkitFlutterPlatform.setInstance(MyPlatformSnapkitFlutter())`.

[1]: https://pub.dev/packages/snapkit_flutter
