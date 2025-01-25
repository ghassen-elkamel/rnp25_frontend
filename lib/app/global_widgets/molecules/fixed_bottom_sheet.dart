import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/text.dart';
import '../../core/utils/constant.dart';
import '../atoms/safe_image_network.dart';

class MoleculeFixedBottomSheet extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final List<Widget> content;
  final double height;
  final String imageErrorPath;

  const MoleculeFixedBottomSheet({
    super.key,
    required this.title,
    required this.content,
    required this.backgroundImage,
    this.imageErrorPath = 'images/login.png',
    this.height = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: AtomSafeImageNetwork(
              host: hostPhoto,
              path: backgroundImage,
              width: Get.width,

              boxFit: BoxFit.fitWidth,
              imageErrorPath: imageErrorPath,
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: Get.height* 0.6,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(26.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        fontSize: 30,
                        title,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ...content,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
