import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AtomImage extends StatelessWidget {
  final String path;
  final int memCacheHeight;
  final int memCacheWidth;
  final double width;
  final double height;
  final BoxFit fit;

  const AtomImage({
    super.key,
    required this.path,
    this.memCacheHeight = 50,
    this.memCacheWidth = 50,
    this.width = 40,
    this.height = 40,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the path is for an asset or a network image
    if (path.startsWith('http') || path.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        width: width,
        memCacheHeight: memCacheHeight,
        memCacheWidth: memCacheWidth,
        height: height,
      );
    } else {
      // Handle asset images
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
      );
    }
  }
}
