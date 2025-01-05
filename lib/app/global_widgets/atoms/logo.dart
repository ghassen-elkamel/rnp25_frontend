import 'package:eco_trans/app/core/theme/text.dart';
import 'package:flutter/material.dart';

class AtomLogo extends StatelessWidget {
  final double? height;
  const AtomLogo({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Image.asset("assets/images/logo-small.png",),
            const CustomText("شركة فخامة الطريق\nللطروق العامة", textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}