import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AtomEmptyList extends StatelessWidget {
  const AtomEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "emptyList".tr,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
