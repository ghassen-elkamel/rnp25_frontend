import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../core/utils/constant.dart';

class AtomCarouselSlider extends StatelessWidget {
  final List<String> images;

  const AtomCarouselSlider({
    required this.images,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 120,
          enlargeCenterPage: false,
          autoPlayAnimationDuration: const Duration(
            milliseconds: 800,
          ),
        ),
        items: images.map((pathPicture) {
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: "$hostPhoto?path=$pathPicture",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
