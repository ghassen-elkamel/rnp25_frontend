import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ImageHelper{

  static Future<BytesMapBitmap?> getBytesFromAsset(String path, [int width = 30]) async {
    ByteData data = await rootBundle.load('assets/$path');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List? byte =  (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
    if(byte == null){
      return null;
    }
    return BitmapDescriptor.bytes(byte);
  }

}