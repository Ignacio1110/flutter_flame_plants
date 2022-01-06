import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//這部分程式參考https://pub.dev/packages/image_pixels/versions/1.0.0 中的程式碼修改用來讀取圖片資料
Future<List<List<int>>> readBitMap() async {
  final ByteData bytes = await rootBundle.load('assets/images/flutter-taipei.png');
  final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
  final frameInfo = await codec.getNextFrame();
  ui.Image img = frameInfo.image;
  final rgbaBytes = await img.toByteData(format: ui.ImageByteFormat.rawRgba);

  final List<List<int>> list = List.generate(
    img.height,
    (index) => List.generate(
      img.width,
      (index) => -1,
    ),
  );

  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      final color = pixelColorAt(j, i, rgbaBytes, img.width, img.height);
      if (color.value >= const Color(0X55ffffff).value) {
        list[i][j] = 3;
      } else {
        list[i][j] = 0;
      }
    }
  }
  return list;
}

Color pixelColorAt(int x, int y, byteData, int? width, int? height) {
  var defaultColor = Colors.grey;
  if (byteData == null ||
      width == null ||
      height == null ||
      x < 0 ||
      x >= width ||
      y < 0 ||
      y >= height) {
    return defaultColor;
  } else {
    var byteOffset = 4 * (x + (y * width));
    return _colorAtByteOffset(byteOffset, byteData);
  }
}

Color _colorAtByteOffset(int byteOffset, byteData) =>
    Color(_rgbaToArgb(byteData!.getUint32(byteOffset)));

int _rgbaToArgb(int rgbaColor) {
  int a = rgbaColor & 0xFF;
  int rgb = rgbaColor >> 8;
  return rgb + (a << 24);
}
