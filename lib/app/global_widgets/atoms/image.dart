import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class AtomImage extends StatelessWidget {
  final String path;
  final int memCacheHeight;
  final int memCacheWidth;
  final double width;
  final double height;
  const AtomImage({
    super.key,
    required this.path,
    this.memCacheHeight = 50,
    this.memCacheWidth = 50,
    this.width = 40,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: BoxFit.cover,
      width: width,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      height: height,
    );
  }
}
