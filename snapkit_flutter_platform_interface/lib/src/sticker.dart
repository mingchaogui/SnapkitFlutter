class SnapSticker {
  const SnapSticker({
    required this.filePath,
    this.isAnimated = false,
    this.posX = 0.5,
    this.posY = 0.5,
    required this.width,
    required this.height,
    this.rotation = 0.0,
  })  : assert(posX >= 0.0 && posX <= 1.0 && posY >= 0.0 && posY <= 1.0),
        assert(
            width >= 0.0 && width <= 300.0 && height >= 0.0 && height <= 300.0),
        assert(rotation >= 0.0 && rotation <= 360.0);

  final String filePath;

  // Whether or not sticker is animated. Only for iOS.
  final bool isAnimated;

  // Position is specified as a ratio between 0 & 1 to place the center of the sticker
  final double posX;
  final double posY;

  // Width and height~~ ~~in dps
  final double width;
  final double height;

  // Specify clockwise rotation desired
  final double rotation;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filePath': filePath,
      'isAnimated': isAnimated,
      'posX': posX,
      'posY': posY,
      'width': width,
      'height': height,
      'rotation': rotation,
    };
  }
}
