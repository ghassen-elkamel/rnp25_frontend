import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/values/colors.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_pages.dart';

class AtomCurvedNavigationBar extends StatefulWidget {
  final int selectedIndex;

  const AtomCurvedNavigationBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<AtomCurvedNavigationBar> createState() =>
      _AtomCurvedNavigationBarState();
}

class _AtomCurvedNavigationBarState extends State<AtomCurvedNavigationBar> {
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.selectedIndex,
      key: bottomNavigationKey,
      height: 75,
      color: primaryColor,
      backgroundColor: white,
      buttonBackgroundColor: primaryColor,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      items: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Icon(
                Icons.home_outlined,
                size: 30,
                color: widget.selectedIndex == 0 ? Colors.white : Colors.white,
              ),
              const SizedBox(height: 2),
              Text(
                ''.tr,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Icon(
                Icons.description_outlined,
                size: 30,
                color: widget.selectedIndex == 1 ? Colors.white : Colors.white,
              ),
              const SizedBox(height: 2),
              const Text(
                '',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Icon(
                Icons.person_outline,
                size: 30,
                color: widget.selectedIndex == 2 ? Colors.white : Colors.white,
              ),
              const SizedBox(height: 2),
              const Text(
                '',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Get.offAllNamed(Routes.HOME);
        } else if (index == 1) {
          Get.offAllNamed(Routes.PROGRAM);
        } else {
          if (AuthService.isAuthenticated) {
            Get.offAllNamed(Routes.PROFILE);
          } else {
            Get.offAllNamed(Routes.LOGIN);
          }
        }
      },
    );
  }
}
