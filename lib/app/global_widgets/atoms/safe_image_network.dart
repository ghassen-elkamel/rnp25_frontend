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
  }) ;

  @override
  Widget build(BuildContext context) {
    log("$host?path=$path");
    if (path == null) {
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
    if (host != null) {
      return CachedNetworkImage(
        imageUrl: "$host?path=$path",
        width: width,
        height: height,
        httpHeaders: headers,
        fit: BoxFit.cover,
        errorWidget: (context, error, stackTrace) {
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
      fit: BoxFit.cover,
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
      ),
    );
  }

  Image getImageFromNetwork() {
    return Image.network(
      "$host?path=$path",
      scale: 0.6,
      width: width,
      height: height,
      headers: headers,
      fit: boxFit,
      errorBuilder: (context, error, stackTrace) {
        return errorImage();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if ((loadingProgress?.cumulativeBytesLoaded ?? 0) <
            (loadingProgress?.expectedTotalBytes ?? 0)) {
          return Image.asset(
            "assets/images/loading_img.gif",
            fit: BoxFit.cover,
          );
        }
        return child;
      },
    );
  }
}
