import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../core/utils/alert.dart';

class AtomSafeImageNetwork extends StatelessWidget {
  final String? path;
  final String? host;
  final String imageErrorPath;
  final double radius;
  final Map<String, String>? headers;
  final BoxFit boxFit;
  final bool isCircular;
  final double? width;
  final double? height;
  final bool onTapShowFullScreen;
  final Function()? onTap;
  final Widget? fullScreenDetails;
  final Widget Function(Widget image)? alertTemplate;
  final int maxRetries;
  final Duration retryDelay;

  const AtomSafeImageNetwork({
    super.key,
    this.host,
    required this.path,
    this.imageErrorPath = "images/image-not-found.png",
    this.radius = 35,
    this.isCircular = false,
    this.headers,
    this.width,
    this.height,
    this.onTapShowFullScreen = false,
    this.onTap,
    this.boxFit = BoxFit.cover,
    this.fullScreenDetails,
    this.alertTemplate,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        path == null ? null : (host != null ? "$host?path=$path" : path);
    log("Loading image: $imageUrl");

    if (imageUrl == null) {
      return errorImage();
    }

    Widget result = const SizedBox();
    if (isCircular) {
      result = CircleAvatar(
        radius: radius,
        backgroundImage: getImageFromNetwork().image,
      );
    } else {
      result = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: getImage(),
      );
    }

    if (onTapShowFullScreen) {
      result = InkWell(
        onTap: () {
          Widget content = ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: PhotoView(
              imageProvider: getImageFromNetwork().image,
              tightMode: true,
              errorBuilder: (context, error, stackTrace) {
                log("Error loading image in PhotoView: $error");
                return errorImage();
              },
              loadingBuilder: (context, event) {
                return Image.asset(
                  "assets/images/loading_img.gif",
                  height: height,
                  width: width,
                  fit: BoxFit.none,
                );
              },
            ),
          );
          Alert.showCustomDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: Column(
                children: [
                  Expanded(
                      child: alertTemplate == null
                          ? content
                          : alertTemplate!(content)),
                  if (fullScreenDetails != null) fullScreenDetails!,
                ],
              ),
            ),
          );
        },
        child: Hero(tag: "image", child: result),
      );
    }

    return result;
  }

  Widget getImage({bool isCached = true}) {
    // If path starts with assets/, use Image.asset directly
    if (path?.startsWith('assets/') == true) {
      return Image.asset(
        path!,
        fit: boxFit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          log("Error loading asset image: $error");
          return errorImage();
        },
      );
    }

    if (host != null) {
      return CachedNetworkImage(
        imageUrl: "$host?path=$path",
        width: width,
        height: height,
        httpHeaders: headers,
        fit: boxFit,
        errorWidget: (context, error, stackTrace) {
          log("Error loading cached network image: $error");
          return errorImage();
        },
        placeholder: (context, url) {
          return Image.asset(
            "assets/images/loading_img.gif",
            height: height,
            width: width,
            fit: BoxFit.none,
          );
        },
        // Add retry mechanism
        maxHeightDiskCache: 1500,
        maxWidthDiskCache: 1500,
        memCacheHeight: 800,
        memCacheWidth: 800,
      );
    }

    // If no host but has path, assume it's a full URL or asset path
    if (path?.startsWith('http') == true) {
      return CachedNetworkImage(
        imageUrl: path!,
        width: width,
        height: height,
        httpHeaders: headers,
        fit: boxFit,
        errorWidget: (context, error, stackTrace) {
          log("Error loading direct URL: $error");
          return errorImage();
        },
        placeholder: (context, url) {
          return Image.asset(
            "assets/images/loading_img.gif",
            height: height,
            width: width,
            fit: BoxFit.none,
          );
        },
      );
    }

    return Image.asset(
      "assets/$path",
      fit: boxFit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        log("Error loading asset with path: $error, path: assets/$path");
        return errorImage();
      },
    );
  }

  Widget errorImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        "assets/$imageErrorPath",
        fit: BoxFit.cover,
        width: width,
        height: height,
        scale: 0.6,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if even the error image fails to load
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(radius),
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Image getImageFromNetwork() {
    final imageUrl = host != null ? "$host?path=$path" : "assets/$path";

    return Image.network(
      imageUrl,
      scale: 0.6,
      width: width,
      height: height,
      headers: headers,
      fit: boxFit,
      errorBuilder: (context, error, stackTrace) {
        log("Error in getImageFromNetwork: $error, imageUrl: $imageUrl");
        return errorImage();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if ((loadingProgress?.cumulativeBytesLoaded ?? 0) <
            (loadingProgress?.expectedTotalBytes ?? 0)) {
          return Image.asset(
            "assets/images/loading_img.gif",
            fit: BoxFit.cover,
            width: width,
            height: height,
            errorBuilder: (_, __, ___) => const SizedBox(),
          );
        }
        return child;
      },
    );
  }
}
