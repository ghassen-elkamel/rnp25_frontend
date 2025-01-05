import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../core/utils/alert.dart';
import '../../core/values/colors.dart';

class AtomSafeImageNetwork extends StatelessWidget {
  final String? path;
  final String? host;
  final String imageErrorPath;
  final double radius;
  final Map<String, String>? headers;
  final bool isCircular;
  final double? width;
  final double? height;
  final bool onTapShowFullScreen;
  final Function()? onTap;

  const AtomSafeImageNetwork({
    super.key,
    this.host,
    required this.path,
    this.imageErrorPath = "images/image-not-found.png",
    this.radius = 20,
    this.isCircular = false,
    this.headers,
    this.width,
    this.height,
    this.onTapShowFullScreen = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return errorImage();
    }
    Widget result = const SizedBox();
    if (isCircular) {
      result = CircleAvatar(
        radius: radius,
        backgroundColor: primaryColor,
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
          onTap?.call();
          Alert.showCustomDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: Center(
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(
                    "$host?path=$path",
                    headers: headers,
                  ),
                  backgroundDecoration: const BoxDecoration(color: white),
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
              ),
            ),
          );
        },
        child: result,
      );
    }

    return result;
  }

  Widget getImage({bool isCached = true}) {
    log("$host?path=$path");
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

  Image errorImage() {
    return Image.asset(
      "assets/$imageErrorPath",
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  Image getImageFromNetwork() {
    return Image.network(
      "$host?path=$path",
      scale: 0.6,
      width: width,
      height: height,
      headers: headers,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return errorImage();
      },
      loadingBuilder: (context, child, loadingProgress) {
        return Image.asset(
          "assets/images/loading_img.gif",
          fit: BoxFit.cover,
        );
      },
    );
  }
}
