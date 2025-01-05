import 'package:eco_trans/app/core/theme/text.dart';
import 'package:eco_trans/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/values/colors.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final bool isLogin;

  const AuthScaffold({
    super.key,
    required this.child,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: context.height / 2.4,
            child: ColoredBox(
              color: primaryColor,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background-image.png"),
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset("assets/images/app-logo.png"),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxWidth: 700
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                          child: DecoratedBox(
                            decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              height: 110,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () => Get.offAllNamed(Routes.LOGIN),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 32.0),
                                      child: Column(
                                        children: [
                                          CustomText.xxl(
                                            "login".tr,
                                            color: isLogin ? black : grey,
                                          ),
                                          if (isLogin)
                                            Hero(
                                              tag: "indicator",
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(100),
                                                  color: primaryColor,
                                                ),
                                                width: 37,
                                                height: 5,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(!kIsWeb)
                                  InkWell(
                                    onTap: () => Get.offAllNamed(Routes.SIGN_UP),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 32.0),
                                      child: Column(
                                        children: [
                                          CustomText.xxl(
                                            "register".tr,
                                            color: isLogin ? grey : black,
                                          ),
                                          if (!isLogin)
                                            Hero(
                                              tag: "indicator",
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(100),
                                                  color: Colors.red,
                                                ),
                                                width: 37,
                                                height: 5,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          color: divider,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 700
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  ),

                  child: child),
            ),
          ),
        ],
      ),
    );
  }
}
