import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:mumush/src/application/resources/colors.dart';

class AssetHelper {
  static final AssetHelper _instance =
  AssetHelper._internal();

  factory AssetHelper.getInstance() {
    return _instance;
  }

  AssetHelper._internal();

  Future<Uint8List> getBytesFromAsset(String path, int width,
      {Color markerColor = primaryMarkerColor}) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
